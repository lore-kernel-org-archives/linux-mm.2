Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1608FF60F4
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 17:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5A66B008C; Tue, 31 Mar 2026 13:42:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D668F6B0095; Tue, 31 Mar 2026 13:42:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3566B0096; Tue, 31 Mar 2026 13:42:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC1C06B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:42:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6308813A7F9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:42:16 +0000 (UTC)
X-FDA: 84607077072.18.2D562CA
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 795072000D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:42:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jXm/rl1+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774978934; a=rsa-sha256;
	cv=none;
	b=ZYQ8SspEiQwqv1Sg+UWpdjbFRdN/BXu/D9kYdk3GjaHuWdZNWnEin9aSVEboMq798mUjtE
	n34r4ZTs8DzxLsOjE+IDUqIAggQAf/P4dRAyr5jylwXhmyDoulaie6Aft/hFoul09FzcbC
	8paiY0iCrMXESjpGZzLTS8N2VwVUo/c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="jXm/rl1+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of rhkrqnwk98@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rhkrqnwk98@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774978934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZLI6FVU+G6sOOSQa08lT3xgheHyGI6Lqkj+r6HVTj8=;
	b=MlaL1AJzsz8WT28TFYeH/LvAloGnEyl9fE5uT2nuz2aHNqnnYcqFBTfnY/w+kUKr1azNUo
	KveUu+KdeF4aOlB8YdNDbpU2fTqhw7lCUd1r+89HiHEBIodDUlXE1FkJNbBUZW4o833be+
	D1zBMv+d6Kp4KqPdHrIVd+oUD6Lj9k8=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b258d93ffeso13251685ad.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774978933; x=1775583733; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZLI6FVU+G6sOOSQa08lT3xgheHyGI6Lqkj+r6HVTj8=;
        b=jXm/rl1+DroEYCiOihILkYazuefxf7fUBGmZWly/YCGAVsJayJ8vyODgQoDUSCzfLf
         xbw+MJKWIVr87P2yIw2QFYRNyYHLH9c156amR9FzZN/ves1eFf3DS/z/3fWldXvrnJ3s
         A/YeQHy2pr0O9uajBN9YdmLK7/9ADJnr9Fkm/Dju53GgVQi5PYXvagGDQHqd135+sdLG
         MEK517oTKGQ0WsTMVx3z8Cn2GOElz173ZmvCSdmUgknvyP6+DpM8rdNcdUw4KP3q6d4G
         y0VttAU+bPkXLZpiiaNCJNlGwC079pE178VM8845w8J94CRl12cNPXJyR8DnGWrN5kE4
         pi3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774978933; x=1775583733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+ZLI6FVU+G6sOOSQa08lT3xgheHyGI6Lqkj+r6HVTj8=;
        b=MB8fjyaYPrVJZnOSeFfCG/4qCYoFumMCf2FzJsmqQh7fhcBE/wYP6QzALwUZYsPa5B
         DqcLsJR3X9JyOKY2qlcFSuhkwMz+/TGw2+P6KjkLjUKDEKdOwJvXePdIx8SzSeamYgmz
         LiDrTtVq8T0GWeFpvIKeecb363M9hyajdUropB3rejt4hS1ylaAWWrv5fY2/p09L9AMz
         /bbAAKQCsQ3V5b2ClhGDuR5wh3O75LqaIkSG5xWJ/U1O535Bb2AN/2QE1EUQGsQN1nOR
         JyOrwBEyCAhc9u7Bl9UqmC/XYVVh6XFtg7QAY+zyPzKak84gMAeMBdspH35+9CHJqYkL
         pXeg==
X-Forwarded-Encrypted: i=1; AJvYcCX/zGTphKBPtX1hfGK6qWwt81gq2Y6rrfwkIVHUfYdZDevA6dCGs5zFXii+YbpQXxVqfIHMT+IBeQ==@kvack.org
X-Gm-Message-State: AOJu0YwGzO4o5NtSt14PY8IZBTyroUyVnw//15nOY6F3Xmr8uLN02xUU
	jlxjOfQwbZ4l6KmbGXST++rPjQC1poa1GfLpKHguJSLLlWJ/fBEFIhpE
X-Gm-Gg: ATEYQzz4OGviqHr1IfCGxj/UOdtOXkMlN9DFe6Q8PdnUyS/JzB2POvQJ8RxDvOoDmjT
	wwXFbPrSD2fx+VOmXb/aLS8r1p5OD02Jj0OJ1dydjhRlqUSIeLu9uFBLL/IoYMFybtcWCcLBCPo
	p5bvBeNNc2Ykh0+a3bKvEfAhdgS59whwQkMvpAdlk1+CFDVGZnCOTGvSu3fDuq1d0nneM8g5zMa
	KmxaA2wlvZ94Kzbv3L7ps7OOmK14u3qdewI0GoYrvIRo1/a/B9eBRPH0dUmA6wv5hWwHfjAJC7F
	puvfPKjYF18cWRpTp1X3Fdba1BX1iXKlve8xOCJcgm/tDXX3ZiXLThbFQh0FyR22IEdWSyXl6XD
	9Mo0ZAjOGFf78/MHrEfuQwAGcwDX219GQZDXy8KUisu4+fydqSWLW7quOqTF9ZqiLBfP+TJiNSv
	f64jltINulxXCLnQbi+bIqSGzT+7+Tl5gqZOVbDR3JySED/HeBGgH0rp4XmysUpQ==
X-Received: by 2002:a17:902:ebc1:b0:2b0:a957:304 with SMTP id d9443c01a7336-2b269a96018mr1015005ad.6.1774978933233;
        Tue, 31 Mar 2026 10:42:13 -0700 (PDT)
Received: from cps-manycore-1.. ([143.248.136.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427af930sm151944705ad.70.2026.03.31.10.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:42:12 -0700 (PDT)
From: Sechang Lim <rhkrqnwk98@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix memory leak in __mmap_region()
Date: Tue, 31 Mar 2026 17:42:08 +0000
Message-ID: <20260331174208.1329636-1-rhkrqnwk98@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <e08a4b07-b067-4eaa-9848-4bf2cccceafa@lucifer.local>
References: <e08a4b07-b067-4eaa-9848-4bf2cccceafa@lucifer.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 795072000D
X-Stat-Signature: qd6jcht83koqx4o7n5s6etfofx1f5iab
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774978934-57731
X-HE-Meta: U2FsdGVkX1+feNfE4aL1/swobOIO+l2LFUw0+jDIQn821JCfB/YME319kMhh1QDDMDBdZ3bI9ikOe1a4sUvQU4VnuTi4ViXV3z2a/GMn2WQgpNPfof6D9FWn73Gce7GAnMLW73KoAxZJ+qMUj0oVMBiq3lqorNiOcaFlAsS8TekVr+wJiuFYA9ZUi6C+ZyEDhP1mduPzOy6tRJuc0KsudKpYWkD5KpoZhBpcEyvbo5W1wVc83O7ZFBwIqEt12a37W2M20Vejn0BS3iqQxD21GoKeqOWyMAaOhxNA3wSVBzBF1F8if83ETU0oQFleU7blLeyKK/6TNIaszE1u30oJng7xiAm2mr4KXNc08sFMAPuOFe1GT/kn1wojnCu40ivbLqnHiqNXQpWBqbdzRRlGMpDua2zSc4ijX65B0sQPOw/vxNE28nsFeuCareRhPd7D/Vy77nZ+zCWBxTTAxBdZHFGWK++OrEsTe/Ghnky+AR65tBx8UrezFT8vLIx+9LEh/5eVsSOXDj+7cGI4E7qz5wQ7RgwyXpgry1CeLknvJ7rBWczn6xNGoiOPC14XJyJcLoJXiEclodJ/Er1NN3+cxRmqVAchxeElHzpnY3vSklN4z5hta+cDMUQyn/nEYuuaX/gYZ0qobiVznJTXwsa5+ZO9FpaR+JwS9t6EsXwahtvBNPwO0krtMFVOLYkwa1RV8yYseMc4FzSexsoe6cDlfSxNPTmxJWpKllm9hc+QO2ZwsRoZ6fFLpakJEetR4G5CBW5DwhbLraejasf/68nUbMvavKxUS8I3Ldx4o5gDePaPiZZAeDkb5weqc48RgESr+ZuM6YpJ7u229+1q649RZQtoUKtccPJjm6HAIw6O8NXR3o7uw58I8ra7hwyeS+MQ7lclXSZ/wKMMXLhLX4HjM8kdm7Y98w2PNzcWZ214FZDIv3AhWAv/VssURsgDIibdgLH7CsC30ZUafXKeSSt
 TT9nVILK
 DbaUxFoYn6GVdsltUbA97UN5CoIUVwMiJb//BqJjn/Uh16s8FCJXH5bGM7Y3wgUMarHoI1lBy15+MxxOL84iWVN8WafG5gVRs6pND1hjwrZg6PV6gxRzyTBVW1ReWat22WOBQaOsODHzFvUojlfAcMSRTsRqZadDCvJDTGV41OL1pzShBCGLyHdvE/v4ye0twWZ+6kSewudFqZ5iBZbc+Tw2PGc9MnI6jfEmnuk7m8w3HxqDtTj9sC6vctotdpyiI6dF/PJekFtWXGzgGjFCZPEOyzJHtqQkL2BnYJs8tBQaggkZ6pnM5TK/XCWNwgwBmUOmHXBrSWUPKdjPbcwhY3tYr8NGMzLrtUwbMY0aQjcS0gOAWq2loNy+4LUo9+EEori/pd4LK69ySpKi8m60Ovk1tuDmZEDeEvia7rW/TZKMkpXJ+8+EWxJvD/uyz76GbHL63hB2WNkh6h14tC63v6DXWd65JQ/1UPfYfRbdMv3/Rpfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 02:30:09PM +0100, Lorenzo Stoakes (Oracle) wrote:
> Which syzkaller, a private implementation?

Yes, a private syzkaller instance. Not the public syzbot.

> Logic looks correct to me, so:
>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> But please adjust the logic as per the below and maybe respin for ease, where
> you can add my tag also.

Sure, will send v2 with the changes.

Thanks,
Sechang

