Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C152EC1126
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF62F6B0005; Mon, 23 Feb 2026 14:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6ED6B0089; Mon, 23 Feb 2026 14:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E04996B008A; Mon, 23 Feb 2026 14:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE2AF6B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:48:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86F3A1402C7
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:48:25 +0000 (UTC)
X-FDA: 84476758170.15.E959CC4
Received: from mail-ot1-f65.google.com (mail-ot1-f65.google.com [209.85.210.65])
	by imf04.hostedemail.com (Postfix) with ESMTP id B96A74000D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:48:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J6JmeR1r;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771876103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfRIPVejaQzatmaR4Ji2F2t82QsJMy6YrYIwzm22g/I=;
	b=7rHtboy8hJUV+tGoolCxus1qk96Xgc0VbM3npCxGYNyfWCXKPM7Whu/GvWeBr00P6nEGmk
	7pCeUJAHL12b+U0NX6upvRkyFH1VllT+Q2rZl6KGGvntoUMvrpPSqjE5TzHu8wpDkLMfew
	03LniXeuJxZKOJVoE41ltnLj0bVwzvw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J6JmeR1r;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.65 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771876103; a=rsa-sha256;
	cv=none;
	b=NkozAH8rxUpzNWTZ4jklbDDQQSnScBmO5f3cQwisGKpC4234FowygVHPn7fUJH0TERvdSl
	3qzjNy+ul7Cu2V+9Tg0xIzB6uuPzxqSnbe93HT8tkeYWMLBQ65sYBqsM6pTqwW0m9r519S
	Fwb0w96+MwOxheBpgn+8sY/dh7VR7aE=
Received: by mail-ot1-f65.google.com with SMTP id 46e09a7af769-7d4c3484268so3378873a34.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771876103; x=1772480903; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CfRIPVejaQzatmaR4Ji2F2t82QsJMy6YrYIwzm22g/I=;
        b=J6JmeR1rxhvXiBYVRN/vmxFHgkXcDBFFDXS1uvoUP1SfesrAmnJ1/j6EEB/mTcXCR+
         ssxLM23ZRYQpXwhlzrGvkYuJzoY9DRFCc1QDrXcWT/6WN8tfpIYG0Y4sJKug613CMtVd
         JfxlhbIU7vN4p9nr9CcamoPUU4WhDQpirJnNAICS3pYTqCnUNO78XeoH2tXXf2phl7NO
         ioPejBdltrtOju+ZCcBO4+emiheuT8T2m0GtajIq2nhSX6qymB/e30diVVvg7H1U7rpc
         QE4i+ct+1AyQMd43FLz7Grho5Wb+CHPHNY7e+q8hVDsC4A4TIVP77yh3O1fOFWUwOyNm
         0NHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771876103; x=1772480903;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CfRIPVejaQzatmaR4Ji2F2t82QsJMy6YrYIwzm22g/I=;
        b=E3zj7qTOlNchGRug4nQa3qM20FM+tZZuGSVZNYqnF+xxmy7sGUmEICK88vRjV9MiFT
         AK48BNfp+lt04dhlINPHx1GLXDExUxPnrLLO9Mf0dibNdgxWh71dg47RBI4tp6hFNMWX
         5y+oU8MjusKYd7fXDdOOqvcZyoAcybhhLaVLwxLf2TwXqJnBxueEyKBxwXtFbP0Dc+tB
         dkC36qAJjGDPF1Lgmd/pllc13EYJ/EhDpdeTRJxO0nJRTmg0pMwSXtntNelUQi2h5/zP
         zjxJ3p9OeQ97B9YFh/LVbJP0wwkUpAXs1n4JggdCq7diW2TykGpIIq3Mfxf3FrATmK32
         2J8g==
X-Forwarded-Encrypted: i=1; AJvYcCXjA6kS7EvD2/2Y6+vPP3GeDnI3eFP7LLU5VXqsd25xSJO0mFo0DZ4aC/KYPQSggrym8uq4UDnSPg==@kvack.org
X-Gm-Message-State: AOJu0Yxzp8d7uoqHWkJM+vu1uK6XOCAf1gD+kFUnjPwaEBCQ80fntpFK
	UtV0z+95E8nUAOgHYNgz7s7loAjJD91fFmkUELimuUkh1js9n0xJ0+6J
X-Gm-Gg: AZuq6aJMW2jD7ui2eMn9GZLaz0z98ig1Z7GaH7fl9IVesj6HkwYol3FZ329fNWybPvO
	LKhEMbncsewbdCDT0f1J/MaEnvFkm5/s+R2aeexSpKTjWo9rrRcSkNGqzNdKIfpfWIyET2BzDr3
	NPorHY6sR82gEVLtU/yJLuDLRlzworqqgYW/UDqhWudhQKegzflgeFrr6CzfhhYbVBRix7iIpe7
	ltBZCaLnoF4/r8hMnrZtodUW+jHguwEutPQi3kff7cVHA6Mf+LIk72BmPPUwnZRSmOZjtluDP+d
	K2QZxQMfdQjjOkplo6UxiLVoaF/EBNruqK80Pd7PG3Wt+W7EIGiTyfy0fFXOfBbb7ZP17a3Sarf
	fNFuxq0L/sgFQ/yT8CXuSh5tgfmH+mw4BCeFEwhfhLTHw93WfPpT26clHcu60CQnk6JfUFzFj2q
	mEJmVG64QmER6N1mghI0wvAjzD9Awz+blbmBvlpQ==
X-Received: by 2002:a05:6830:6f43:b0:7cf:cd98:b3c5 with SMTP id 46e09a7af769-7d52bf535f1mr5740241a34.31.1771876102722;
        Mon, 23 Feb 2026 11:48:22 -0800 (PST)
Received: from fedora ([2603:8080:10f0:ab80::1382])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d04de97sm7756698a34.21.2026.02.23.11.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:48:22 -0800 (PST)
Date: Mon, 23 Feb 2026 11:48:19 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: vmalloc: streamline vmalloc memory accounting
Message-ID: <aZyvA32J2RQ4z6VZ@fedora>
References: <20260223160147.3792777-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223160147.3792777-1-hannes@cmpxchg.org>
X-Stat-Signature: ffbnpc3r3wjctq6uypr9yhmbmrgkyyks
X-Rspam-User: 
X-Rspamd-Queue-Id: B96A74000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771876103-418590
X-HE-Meta: U2FsdGVkX1/j2vzece/dfq9gobVMpaHafCTwLjLAZlu0QokG8NpzTjCV7NZ4zAtUbt7H5RpzYzB7wl8I2leU3TCYA3/bx2lEI7wbusJsqqGGWWULueJhhzKXFzVE3UJHN6tIjyIOOM/tKUq6Ahq8CWeullzROOj6IHuKx/dzDM7ffNHwAOmgZi40+OSIYaMDWleLUdWxXD2VszyV8QVVjcGTUgYJSAn1qnGrYu3OkBsvrpNQedlUp4vZQukKhslmVxc9Yk82Xk2S1F8HYwIMnDqBHGBS9L2EPtKUe/nXl3QrjpsGI2y5linGWf9DzSzz334OV2rfu2z4QLXET23NedFqtxJhJceeZ33aotjYpX5e2Bb0bHbs6D+hxs7X7chuAVW7qY3PMfan2FHOi1Y3b9+dxOKwyESNFyhVC8/HSnFayEF5aqcf8n9JW1s8YEDeNPZ2UCPnulCQd/km2kgi1zZ3taHFch1iSsjnLmf+07beZA9em/Ar3ZLXVdLyoTFLptnONYl66cvlAI6nj0gCUd6DEP8Irgw8VieLMWu1vYNPHtlcKZ0WW7Hfz5SPhhrFuN3iJJHylCo2d4IiIi135NB+J0IFwA5PGZJlQyawiVJgNIqwkOSloZOKpQEh/pZ/Il/2vdwpZV3Ug76nJgAWmBsv+1tenUXpxI8cLRnG1tYZDaj6BV1dadwUh++vKhoPNllHJ3VBFVljgsd/lW8CLLvOPW1pK6G8GhjvNctS1XRpE3TpMji+/GhokefqL9TQ5UY0XKw4r5P9n9ci/NWTBQjzF7JobaHLT9C09SNTd3uu5jaDqf0OU9yXHOC7euMXS7h5s/2/hzCsuixRS8XWjzLD99Q/n38tTr/iZwur8LcVSFrHGzYmK6PExb1vwqCtzlgC1DCxQyjmnr5/tbA8eipcPcDn8ky4E1QuNOa5RdQBzdlwMiS2vl2wlSQANaWWqUtXKcflryAzSGpRPQQ
 Y1oOlDZd
 zMfOu5YTcHuUlVk2S+MfoY16ZlnWawHJXNL15SDZkXqvMyaygfBwdaIuGDlIfsxYlrTIbrkHn1WOAid28jtcb+GvzR40SL2luepMEph+GkXHCophM5p9E3OtnLWIPuay23PeaQXZjZww2qd56fLom6Md3u83rOg0+/bkl4aV6hIe5eHRmCxyiABOs6FLjECyQ3lcj/tlstxfoxwi3DE0NJX/o0LH+mhWMrf/Xait6wLs7ewxPtJCfw02wa3O6FoGoL9hOYSqHJ2bxijYNi9pUKUinhf8siy+HFpeAPNJ3xnRmd4pjb4HnKPVTTKiBiZdm6HIu4+ZP48bCV3PKx5KGxejVyMq5Hz7GlSEBpq1NbhWZFg2xQ6YzG49rU6dU6yH8nuo0c2TBxrJzsEj4e+veg4K39GAbkmSEK2taobAu7UUGm1Ee4Ym5RNHPVpATXeqA2huwFc+AHEDSnjtHZm485IFoGDSWY/WK+l0/Hajwf6+yPTDPkOhZX0jCakK2s9F2SqXHnJcv1LeQ8KV5OEnkX8lEX2hfCm5vV4zjNAf37ByzJxEMtFf8EnmGnB00niit2IAO/S5hCuomB6PacssNMz8m/k3EGw3uwNaghhBBsz9DiazaDfLZbd2acw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:01:06AM -0500, Johannes Weiner wrote:
> Use a vmstat counter instead of a custom, open-coded atomic. This has
> the added benefit of making the data available per-node, and prepares
> for cleaning up the memcg accounting as well.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

