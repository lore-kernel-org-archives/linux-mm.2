Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6419DCAC5B0
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 01:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7D48E0005; Sat, 27 Sep 2025 21:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78F08E0001; Sat, 27 Sep 2025 21:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E348E0005; Sat, 27 Sep 2025 21:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 993518E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 21:32:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3283511B032
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:32:49 +0000 (UTC)
X-FDA: 83936934858.24.9385389
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A56814000B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 01:32:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hm2WjVyb;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759023167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BNO5RZIiIrulzG4VB12ipNMyH0eEypFH/dltlbXSWN4=;
	b=uFB0VUUghnLWFc/lGBS/zYPJwsJVTaAGSb8ynPY09DjUlQY/saljfp8neWSYetNnzVBKaL
	MMyBhqqGq4GIj5jf0XAW9PA0C/V6S9A2QRJfkZDkYdppNqHOGM8rJbqQflpxG+GAbo4PjT
	8/RywvASVnBPCaTdYrQjvbSholhgyL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759023167; a=rsa-sha256;
	cv=none;
	b=X/8nPJQhirZy2unAWVPNHd68B25nMSm3Qq4iAW4RaiY9gtrGFN9SlIRpL7Rzc2uHlGPzfX
	f0NqGo77/tDZf2U7a105A9SL6349FJHtPSAUSmmGZ2CDjugkFHu5j/gbcohRTMJULRileB
	0XzYmg0tglqAbvmfXHBpbCkf5zpsWfA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Hm2WjVyb;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3d5088259eso11939866b.1
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759023165; x=1759627965; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BNO5RZIiIrulzG4VB12ipNMyH0eEypFH/dltlbXSWN4=;
        b=Hm2WjVyb3Dygm5908Glg2lHgTKpVcO/zGbavz9elieUJcplwC39SkQ9j1hHPcP4AHm
         mloIe5X6WlXm6462cjPY/FrWJ7gqA5GQNJsr013dwel0WTip1DnqM207zxNtb2qo0wmR
         pp/nSFPXIQDEUTnk2bn+1QzLB9gXvr57sT41nKZCgftfSbSUzgTPhJbX13+5K3Fhg9S7
         owHas6yb96USmAsYSc9cAGr8RGXsCD6+yqO7cNFdJEtlNDLzvApc6I9jcQnAgQGBzYMD
         tyffcaaiW7K0fxNOO/VuWLonKtFsD99OdT8LGffvLE/E8I6XuN+Q/+4/Z/LoeFiX1MQz
         7ckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759023165; x=1759627965;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BNO5RZIiIrulzG4VB12ipNMyH0eEypFH/dltlbXSWN4=;
        b=KGiTp/CUv4wm9fN1SFbIbvh3966uDEJOg0i4aIIwHeAo5oMs6DsWGYBUgtxM0GX7Ra
         qqXN2xAGk1X8fxCTXHCZ6YH3nzHoHA8jxrO2tnwyy9p8RMM+G7yBEijHoF9CwLawCZyd
         PFWMKgv+5GkGngerHayl3BfG7mLzypKGg6cim+AZ1FiSv195O38ciIpFD0QI4g5qKCZq
         jgT3e7kmFfspPaOxjHR4l0KpbPdl0fhLL4sfoxzGloBMXnExmgBc6gFxDuWaFtHueaxN
         gl8+GNnEUbKuWb65PjD58IN4hJX5V+J760tu5GfupNzT8YR0ASN/XHkgWncwl2KH+uyB
         tJUg==
X-Gm-Message-State: AOJu0Yz6yWkOyEng+ER373YvOWaTtrshSR9zIHHOIwLpRuNg8OQEft6Q
	0VMx9I8P0rxmlEoWlwkPyxoTQc2xEcWBH9589lAQLORAZYGpmw/cbG9k
X-Gm-Gg: ASbGncuUiO0GpYOlBuwZwJnyB5Y10ahmNP4wuua0oxzu2rcoGdnHlD1AtmnztYlWxyg
	YFVgHWGxnjl5nDrAhHcEH5KXAB6Qm/YljxBipqe+lPkG6i35ayBydjx02dwk9UMg0Wbr6VDgiu6
	cCbk4L5S7BQ2+Xs9A7im8LwSOti+paz+VhQyCW7Hd7CL5MecguCsi5fMd7FQF98OXvsMWl+7tCv
	HnSVcLDedR3nKieLxUi9MloBgQCZnlvRk7Y80VShLhOJgW8bTDQ0uiRC3LCRk15eGM8Q3WGkIyv
	sVpjAu2ocblPyijTJFwX5Xf0IQtwyx+Z+ZNJ5WGuv7PvM0st/kKmlzq0seX0GHf1eQqmYkSsEh5
	Cd8L44lyzCoSz0pWXnqdMMzHDqQ==
X-Google-Smtp-Source: AGHT+IF+0HY03khXHDHlsMivMc7NYqE4StkORboEozoeR1pyX7fRDWSjBmKKhZE6NSjOa1T9ZS12Sg==
X-Received: by 2002:a17:907:3f10:b0:b10:4355:2e63 with SMTP id a640c23a62f3a-b34bc67ad82mr1406794766b.46.1759023165482;
        Sat, 27 Sep 2025 18:32:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b35446f5c36sm657584166b.54.2025.09.27.18.32.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 27 Sep 2025 18:32:45 -0700 (PDT)
Date: Sun, 28 Sep 2025 01:32:44 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "jianyun.gao" <jianyungao89@gmail.com>
Cc: linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
Message-ID: <20250928013244.qzevjut7gbxdbyli@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250927064926.1496579-1-jianyungao89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250927064926.1496579-1-jianyungao89@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 3A56814000B
X-Stat-Signature: m6dgz48ke5t36b1xw7jc1o3n3km7h3og
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759023166-418513
X-HE-Meta: U2FsdGVkX1/5XeiJWeVggErTW8FufuQ8jzfe46AHr4gZemcWc9gyc5XD0xE/BrpKSETp93RXGUvZTb9iCRAn+4iljhwTCr5Hvxs2EprCDB4vvYG7O4AucHbP4DCvwHE0HD6FgbBKRY7IZ/mDJ39d9Vk8xlb+w5+MPrQCFLnhrU0zEBxyMnvrknN5WaHJ+pKpnJCpMDMrSW2yJv7/N7AdLRBW3KQNuMNCF38ABGSsMgy3V6xY32JFI5G17PHx9z75mROUfD/S7vt+7VXbMCpH0PwkFdUd8bFtk2B+yTPpz1Weq3uE9WKrdRO9AWkyhoVzNbAscXnRUhVvh9PZsn/msk+VDWhGUtfrYbws25nx8hb2MicYwinAVnZFfJIgEz7F4dKQmdCzhcRuGcYVwmN47HL+/BiJu9UowspERE4DyXFuyj4FLVAnBuMt5vwSkYbVDogaNZjS+EMx9xXZK/HUTMNwiRENqTKQGqYusKSRunZZjLqZREBgGpoCCIyWvsQiDcqRoga62F+CyTBH68J4eCsnqC5N/zBhM2R0EZRvLnHDNgZwK2q5O/nwKzZ9IaW9wFE3/uHHm5jBDW7C2k4PGR2IVncWAcZ/tebImBrP6reae0ykrVZont5xiHUkR4svJt5UFU+hkE8iVVLSHl2qvlRpllYyVzij3//0/0EGy2Y22glaIAhdhDoitUgeq9c+X6Rbnv3c4Um6nHJS8DkMIT8znfp6ZgvAOmQV1h9r8D/hlj1NVAzYZG74Tl/1OoYWsMeiwBTiXsM2d47tIj4OcJWk8GPzV6MWgFjKJsWFVAUL17gdnzli5Ezy1p94UJ5jqCgCybv973UCVTdIF9PENVuFrLfWLGg4KH0DLJCGWEdR+xXFNe5vaqF344TGGO4ZotLsrhfoxKsRV51hRe4/tp/pQGLjmeFEWJ1EEBNomv1wh642Lm/btNQ0GmsidWQ2MhD86YFXMymw5sEoFPQ
 to8IDe2U
 gW3r5sELWTa3bisKSB2S1s6Gc4n11QA8XgmFPF9yh1yZL2mCIpoegEGJ0AZflDcDFVRDH5ApCGUerfijdHzCksghW9qKOVUVAdFAdwereWYJzo6y2TVMBfEexBzEGtHjPTkMFGdWa/1mbZbQ0s5PjLSdnvhHdXcbaQmYS8Tz4EQYpVoNynYs2CIVD858UX6SGmQC6n+wP/uXKlQ9FCIG/jgdTrGspl1nxoqWKRecCcXfO7K3vDB7IL82qsvxt04G2nZT1XqtX3JDS6y2WL5fcnv7FXdA8/f8dYdBawczaNzRYuXOnHsltJ6AYoXD+rlNInUvGUP6Aq5mR6076U/8+Ul6AJ9qydOwOWyCpUp6VXlxMoN3KyZYifdybOjdy0SNZ5DnjGZLYZYgv/WwVrv7D3XJNdR65th2SfnSFWR1CaXhWVLXb5/3nH2E790EaufDzNvzQUVXKTDP5ikMN2ZZCBSkHXSD+rrh+ALx7xId4ozIWNXPP/TD5ZvOUWKBp+1cNkyNSzc8Mv3KNjh2AG9McoeZNMZBbF+/4HycmI5Y3UcFD4abDlQfsk77RLonCaBP4Vh8sQQiAu/QECqa1eN+9ZP9duW+jrUwjzhp62JoOoyoglZkm+aaCpprtCEsLKBUwtlO13OAZ8C4LDPcDsSyPA+UWhD65uWH8mHGW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 27, 2025 at 02:49:26PM +0800, jianyun.gao wrote:
>There are som typos in the code comments as follows:
>
>  differenciate ==> differentiate
>  refernece ==> reference
>  permissons ==> permissions
>  indepdenent ==> independent
>  Spliting ==> Splitting
>
>Just fix it.
>
>Signed-off-by: jianyun.gao <jianyungao89@gmail.com>

The change looks good.

But maybe we can merge it with the next one you sent? They both belongs to mm.

-- 
Wei Yang
Help you, Help me

