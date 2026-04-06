Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471F0F46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 18:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF19A6B00A0; Mon,  6 Apr 2026 14:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA30D6B00A1; Mon,  6 Apr 2026 14:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9920A6B00A2; Mon,  6 Apr 2026 14:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1276B00A0
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:11:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BCF013AF47
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 18:11:22 +0000 (UTC)
X-FDA: 84628923204.02.F11241D
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4C3552001A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 18:11:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDtAUEJM;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775499080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6TnCmX+3/CCMvkLoaDVEag7E8oCzFpXmbhOnswXUGMo=;
	b=Dhx8aSPIon4Wc9nLN099H88+qAsg8VZthl5g31lyVvuAyrAf9Pc9LkKj5cRpdfXru7EFB1
	1ywN4kzLcPRLE9j4os2qdomqaNhB0uV+CRM6swFxGc4naYpc/jwioI3rqHbijlaCOLysw4
	3wLGFEsyCvx60nmz1GSPM3quTmroxts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775499080; a=rsa-sha256;
	cv=none;
	b=8HF3lFAbK9dUy5Aw0BlLn5peMKOeVWy1VOj+WMghcF0WC6srySd7KCf1S9Wz34oSHYGQop
	s5aRfJ6iGs60HrjyQShf2aZQigz1/Tv98g4I9hfmNGR4zgBBoA9v1vAAi1nDUO/2SBYLNu
	l8vLU8pyyTJH/c1cd/QVvgry20UwOm4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QDtAUEJM;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-415b23dd6e5so1623266fac.3
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 11:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775499079; x=1776103879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TnCmX+3/CCMvkLoaDVEag7E8oCzFpXmbhOnswXUGMo=;
        b=QDtAUEJMdLNP5SpBWlUFEQkvfFD4cZpdjtA9gzNDInh2kmTG1skvIWdcXLYu/ANh+O
         zQ6fqrPaCRrAkoEzIw97zaeZ8J+HhO2yR72wm3OX48ds68mRU4+Z9c5PCygzBijtbiEF
         qE0Pt05hdF3qqhK75kuHZAF4saO9MELrrR1aASb3JS1j6kk/K7NGoqWpRFeIdSTqBCng
         KAPdzLhg+uO3WnTFZwfMHoG9QvZWPk/4viVdL49Cbx2KYXHTpMebrYAmoT7SxeK2FCjm
         HnqH+vmJMvPXfHn+V4aTljPgBW9CnvW1PeVhw8QHbRpYw+9okhg6ydaT3S83wBWp53ZE
         GxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775499079; x=1776103879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6TnCmX+3/CCMvkLoaDVEag7E8oCzFpXmbhOnswXUGMo=;
        b=N+dJa4YjMk4FiRex5T0EJM+AzDUiJ/A/jyRBi9T81LjKK6vRZhl6cWXMracPNU/0BE
         /mJWLuX+WGbhbgZN3ZRdyfDf1c1HhNbbNpc/veMTXIs+EAiLJnpJD67Jt89ZZUdKgthH
         ukUPysqeKulPgP3IHNLiAz6zk9PB+r2Ne/m6xZNfe+/rMQVcvcKbGpbL9w+j3fDGZHU3
         6wKP2gsSjbVMgtjD+6gOnpMikAxp7Qa4OeB2tJceRm8e7aS6RABpi9U80N37ILGFTGqR
         a/h6QwIZ5v4kq42SchUZ8b1ZTKqsGtTNOGK09aL/K2Y11o9kVm8Lx1C22ID0hV0QjlMt
         k+9A==
X-Forwarded-Encrypted: i=1; AJvYcCW5fL5db0r8KJ9wBh0r9PTLSexLTB3DRaCGYJaG4+M/cW6wMzDAkkWnKRSMFNd1gNpoUGZEpj24mA==@kvack.org
X-Gm-Message-State: AOJu0Yyy59NzezB2q/6nOrZja+2tr2NPhPt2hf8z5YxS/3673thhGNHD
	iJl1FbUlpCkeN6kOs5zQ8ybllmu0zwLviCVuY+gfOA9ScPJS2ip4vXrm
X-Gm-Gg: AeBDieuG8/p9Ir0V/krLSWF4FlWJL3lzN3LFIl40F1mArLA9gI2yGHgJRxe6hxf7UBu
	dkiAEa2FAjrRdHvtyBORlkEFT1MJ73W19KvarE4joU1edEx6giICD7ygyy+x0HWJHgrby7bpjR/
	p4XHiNVzxaw+ol91U9nc1zgKrPNibGlClFvyorrMXDywaQSRmZ3GwQx2vZeVBznvxqR6FRfPsn8
	ROJHaBe3jW0badVxfkWyEBK+oSAop5Dkzhh6+XtIfUj7SZ4y2V1i/lcAau47NVe7Z2Q1xbPWcnW
	fJqIWN11zDnOf+JdWcVkc5gSxNJ3y+Oz6Txgn7nzfst0vCvobTVs6ZktfKwGYB/1wpDviO8IRjq
	xOO1Nq/7r+4DjMzXKTpEJPofq7Nyf55corY52gcgrUAnvbcHxsXMjB0zjDX93Zy/Rn0VkgfQ99h
	QV2eB6wjpBE5FIZQe0kjRApg==
X-Received: by 2002:a05:6871:2313:b0:423:6559:ae4d with SMTP id 586e51a60fabf-4236559b3edmr2499144fac.37.1775499079203;
        Mon, 06 Apr 2026 11:11:19 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4232eb3d0e4sm7345417fac.6.2026.04.06.11.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 11:11:18 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 32/33] mm: memcontrol: eliminate the problem of dying memory cgroup for LRU folios
Date: Mon,  6 Apr 2026 11:11:16 -0700
Message-ID: <20260406181116.4053796-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <80cb7af198dc6f2173fe616d1207a4c315ece141.1772711148.git.zhengqi.arch@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: amoa37bbzwezxooryiq64ufoeoa99o4j
X-Rspamd-Queue-Id: 4C3552001A
X-Rspam-User: 
X-HE-Tag: 1775499080-951839
X-HE-Meta: U2FsdGVkX18ipxzwv9RflG3mRIWKVa8n/AZtYNNBtPAYwlhpRQOKzISYXI4sCitBO8gSWY3U4Jfgw6Plzf9eXmIH23YzwHJwndlWxP/p0IztQTTtXhvgQdq6Cym+CwxHIh0y6SE7t28IAg+iUcZryN/9fUJgbDTiWWhN8fZjox8UtWJs6K08aknViVdEtXwTeMowTdXjdWscqj8pxq1CTxTsEc+qC6jaoB5sSSea5zBC41z3vjDRNdljwsK1sdO7GBLez7FpP9rILEB3vexcSvsGY9DT9Sy31LdXrxCDCfBThHke/d4LjrNcmeVa4ANVJv81d3afOWEqd0PiJIP5/go5Ft3+VQnbLeh93kRJGYIdG4NgG/ohTcXlwZW36UdLrEzaEzgCov8yqPxUrKVEkdVxbyrVzMwTWyyuLJPiE4tpm9RW9wELGqI81ZYRW1HgkKgAo+HFNVqCmzV6L8esB0/5loCnlmaebGrnDipf46q2DeYkNgCO/5kiPvDA3lHur+7FUAIu504rhtVW7961SUKN3zEjIF8kX80zwLL5x+40Exi4uK9U3eoHkQ1j1zOWp2U3lAG9J9K9//wCxei8ZE5fCBb5CRUk7gP7HEH/XCQE3ZfpACV16XcPNC/chwqrveGAK/N5lSmTjQs3uuycRvkLBVI6yrKFjGMux+93zlhsg5IAPMnLNOHjpTdeNcN1HJnuOFLPtSXN1ZTUqRbFwDym/zNx20p6d50zNTy1KH7BvbFJp+lSUiXO4u4GBCIITPTp7BNOb8eTOeB9J4oLER7ercQB8dV7elXjvtVbRaYphu47p5dApHuO2ySTDlapTlk6e7kdsxkSVLvNC6gahDzQKrxkD/N3n9ehBR27vu1qhd7/qjUqdqzth38aCGbQo4LMNZRrshzY9YTcah0d9SUFqvlN7iBQvVSLiw1Mwe/pF5kEo6K2QWk8KdoisU5wd5RFxF3mwHY+7Qdsckm
 +OCHslia
 AYYupoOZb38ifjsUiEsFqh2QpvZkyNjm3bOP3O4g1+I+es/zLrqqLALRSQ4AE4K3oX0s+dg+6bP+HcXlQ6r+JpEjFEAb8mw5gAwZwGs5O3+m/jNMMRryKZuRezpI7R+GAB+NUs5N2NDXq2XSPqUWhL2Yt65BepAdY4GzbLBR+qsGUodIIAGtBTyrGRVjRhtgLZvq8ZGl13qH0v7zxovFv00+E8peBYg5wzt7adM5gYUFsNFgqZwUlXjy/h5msCt0d2LUW9gFZkjXNeMnQTN/aLrP8xmickW5WtSk0oHIPNgXP1i3mnkyMfHSmm8gC+JUqW/hv7no/buBwT1ZPHes3r9Y6/WtepGNyRM1yqxCBnyALNsLTYHZupAwMR0TD+tjiGmQ+/2Uff82ymeM1lbEGUiULIGxXHkbJe3Ua6+Iy8Ayy5RMUReZt3RYGmiOoZsSHDJLzgKBQ4v1MXLf9q0Fwm53l/+MBVn1tU+c76gHbwqPwYGkgbMptHh4mwXVvtvg4vtYd6/tNddkuFvtB+mFYXESOiNv0DLnUDVQs9Zt+N9nCRpGkmWuSeBdiGwb4Y+hFVqJt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  5 Mar 2026 19:52:50 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> From: Muchun Song <songmuchun@bytedance.com>
> 
> Now that everything is set up, switch folio->memcg_data pointers to
> objcgs, update the accessors, and execute reparenting on cgroup death.
> 
> Finally, folio->memcg_data of LRU folios and kmem folios will always
> point to an object cgroup pointer. The folio->memcg_data of slab
> folios will point to an vector of object cgroups.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---

Hello Qi, thank you for this series!

>  static void memcg_online_kmem(struct mem_cgroup *memcg)
> @@ -4949,16 +4985,20 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>  static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
>  			gfp_t gfp)
>  {
> -	int ret;
> -
> -	ret = try_charge(memcg, gfp, folio_nr_pages(folio));

While developing on top of mm-new I found that this was the last caller of
try_charge(). I was thinking that it might be a nice opportunity to just
remove the definition of try_charge() as well, maybe as a clean up patch
at the end of the series.

I see there are many acks on the entire series as well, and I don't think
it is worth doing a new version just for this. But if you are planning on
submitting a new version, I hope that you can consider this.

Thank you! Have a great day : -)
Joshua

