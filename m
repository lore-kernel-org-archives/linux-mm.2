Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E41E7491E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 09:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29A36B0088; Wed, 24 Dec 2025 04:23:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13DE6B008A; Wed, 24 Dec 2025 04:23:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A616B008C; Wed, 24 Dec 2025 04:23:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C43386B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:23:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72219BA5A0
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:23:47 +0000 (UTC)
X-FDA: 84253827294.05.8DF9CEF
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C1C8C0010
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 09:23:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9Mmq7Uw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766568225; a=rsa-sha256;
	cv=none;
	b=8XMGE0seoaUVkcOYN5jz7TIL1PNR5245mirPaishYkJq9OZ5zPXJWF9aXy9nQ3ZUquYjQy
	rdGqqTivyb8tf3M/InVvJ5vrc42b5T/EE0bUt0tm56opMp+uyX6KU1MddwF7E/Q6b6BUVZ
	WEIgKTtO+kuK1+Ex5ummr18CZ4lyBGY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M9Mmq7Uw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766568225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8cH2GMZHe/+WLS2GkOOrIpCwjIA+oyisAtZxouh6zY=;
	b=wUzhBmlCbybCoMGHoGoMqUFYrd4vVHhYVRseyDzO32AeISOUAXoLqlppwUs3O2RKd3e+HW
	y345f54yPsmURmetrYVpA9mOsbHvZ8YtrBlsw6jIW8hjhotxdBdMcZwQakk/lwDZW83zv+
	817GN0LX+mU8yOUNtfz8Sj9tdzjzp8Y=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-34ccb7ad166so5448736a91.2
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 01:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766568224; x=1767173024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8cH2GMZHe/+WLS2GkOOrIpCwjIA+oyisAtZxouh6zY=;
        b=M9Mmq7Uw+ohK49/4es/X2Wt2FYtpqvWB1LyIeZIV+6CooNcdLoPIQzPHhGZ16DWdkz
         6aaLc6DFxu8yau9zQSIODXE0xVeWNjgMk0SgqPXq7TE1/qCKgnOZ0Vsh3vdae249xYAF
         bgG1nAFAaKlWm+HrhLniNY479Vn+ElSK3T863moddcsidcp6coTKzrTNjrUiRN6ELbzf
         rkR+8njXRR5JOJVnt7pSeURc05O2/24v/ofiW55QFyYerLpgLE6nGrQPu9J+0XMLW1vI
         wYhkw6RSjgr09eMfcc7SBXgjuM/8K/Sr4wHVzXRrfceEFMo/+K1X4e88EeqMjWqXC1Kd
         bAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766568224; x=1767173024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8cH2GMZHe/+WLS2GkOOrIpCwjIA+oyisAtZxouh6zY=;
        b=swFTF41iXkY5Et+L+HWbiEX7RF8GkclNdN1EMQwiZFtLsvhpVkdFECYSx64TSrk2PV
         iLUDVWFfz7yqrC47XF7axES3Q5i1ytwb4nMTJNMNh9UZJFQg9+Z+AmUH2oV0oCwNWE3y
         Aw53TnQ9kOZXUBIMSCi63jZ7F6ayJINd38x8wRvIBj1w45RXNLu8hFgBbNcYwUmFZiMO
         R/wRpvheOSPnAGrMtB3j7mkqEXaueE0cqG00YE6Iqknfcht1LdljaAMjrpnNkfE3MIlD
         zF8H67/Y7nD+a0bDu88lkZb+cXqLRwD/iLrMafWYSRN8/Yl6/6NXN24TOrOhmj64qklH
         BL+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX6jIh5iAvCphcRY7x4mGT+N9GiY6sYDcqLmGDFG1IlDC5YG9ol2tf3EN5Ko8OVlpNXlED0Dys0wA==@kvack.org
X-Gm-Message-State: AOJu0YwRO0Ll/nF6BA88Y4TTlw4fHiaCeidt6Myqj/hDrCv2dWMITacf
	bYLOsdGAbYQLO4sy6NVozyaBVSnWoXTkWezhUlLuudHDSKHQQj54gzrZ
X-Gm-Gg: AY/fxX6Kz1kL0fAfxkjqFnsgXFJwApJHJD7t908wz4PQC0a77NuvLys3jt6v+w+eE27
	LBm/pHECrcfvYiu3BRGDyohvfaXArioJzSg1GM7/4Yt4jBoOMCly7WOfQBeURpcRvvZVPisWltE
	ryS3JEr4kI6N/aUlP2EfOLqGEVUe2eP4dt8heZun17smML7Giee1cKBs+4jBFQisYHoBZc5w36p
	ss1lhaBDdNFtUXfIMOhsvu9VHYRjXsCoG6jZP0XyEnI7iXQPpJfog14tzDoI1GAbJhmUrSOb2ae
	7oa1os1gBS+RjDTu84ZqnWVSq0+WrKodhGkwqQN4mj+G1z75vIc1hy84MAL1MhngVl8ywjsf+N7
	CfoPL4iKzHcHLz0i9ZnFtSm3IAcrucajigVyLL9e3VoTD7+42J28VbG5U0DZ96iFOCKzR33NLAt
	Pv6t6gwqBQdGeXpQpCjnJCMRtZBFdulhp/5EoNf1pYQCN43VsiXpkLGj+G
X-Google-Smtp-Source: AGHT+IGfz4jE0gyBAYJue6cPvqgMbDaJgPDREtcU6RY08FJIcWaNTfVbyhSvT4y5erQfC+/bhA7XkQ==
X-Received: by 2002:a17:90b:3ccf:b0:349:162d:ae1e with SMTP id 98e67ed59e1d1-34e921f7eb0mr13103802a91.33.1766568224256;
        Wed, 24 Dec 2025 01:23:44 -0800 (PST)
Received: from EBJ9932692.tcent.cn (61-221-120-112.hinet-ip.hinet.net. [61.221.120.112])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bc68ab5sm14625908a12.17.2025.12.24.01.23.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 24 Dec 2025 01:23:43 -0800 (PST)
From: Lance Yang <ioworker0@gmail.com>
To: baolin.wang@linux.alibaba.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	chandna.sahil@gmail.com,
	chengming.zhou@linux.dev,
	david.laight.linux@gmail.com,
	david@kernel.org,
	david@redhat.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	willy@infradead.org,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Date: Wed, 24 Dec 2025 17:23:32 +0800
Message-ID: <20251224092332.53214-1-ioworker0@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C1C8C0010
X-Rspamd-Server: rspam03
X-Stat-Signature: zqcih83ktsg43jqink3q7pq3e3zcfyy7
X-Rspam-User: 
X-HE-Tag: 1766568225-340010
X-HE-Meta: U2FsdGVkX1/Eioaoiyqy8JXVqjBv7ZfA8D/MmjyBw5lpqGnL+qZnkZQfpVm7q2PibaQP2mpm4zHWzRbBcdWpn+4VK2+qLZrM5sSIKkITjGpEdO7HZx25NHSK6mG5IeJfyLu2fFMNQgKrRvI5GJ4eNYoKAK3bquYJNDNSAaWwtACQhPr2o5fOT8Mtob1YRH7yfip+guolur6UxGhyJcd+gUA6g3HY2Klqp85qgUO5EtP++n3JOnbc158h2Lv7ux8JaPu7P5Vbt8e9PkQ3hR5HR6ewdiLPGDlzb95hwJsvAXQkLRN12e2d15vXsCBbifQAal04T2NAwIIOPaQZmy8/4llTOLkmIOvNfVULpw4TdziKuppdwPWrVfVGhsfUhHUUeqm4t2dWAD+Gd0uP3hBKPSCNUiMwti0W5X6kZ1/quPMVUkuvjY1B4m4Dat4+jnP+l5c6VHhtOlhTlOUa5Vgt6V86jQH5YIbtL+BEnjaHTKCvskaDjlTOBdrDHr8UK3FFKvvE+0Yg+lyMaRv9bP4VPn633CTYuNpGCzBtLe1mfE6KEgyqKIcc+INzp8lC1KmEcJOUI4ozymbFJNW+3tNl4Tyen2is/f7HslRJHIdurxGdqnU5XX+6mkUl/Vx147Mt4t6escbOBFT8YASGu7s8XN3rCJp/CpS9+ly1SnCRCTIXEz0jCPTIj7Z1soU3+/eS1lJMhx0bSoDVIegrfC1w7bo9S7vaF2WHDLAJUSUSlc3s4clHwc3DK7eKxkS/x7LB4q9LD+9+mMYRgUT4qRZsjiKCi8vRSWvdJPS4K87eaRDE/CtDva/DXQemnpLdQuZ8kYc18VBmG/Fi8j+RfawV+q4G3MyblgjGpiJQzTBw3A7zbyTFbqJvrxFi/uVXzjY9Yc2oPDRsd66jURupnynkvFgBXUXPirQklu5GSymP13K/0Z5fYVyDKbzCqMiihKUa45cr2pu8H9jMgXXJ+ge
 nkApHCqL
 FxZbNonM56KLBoR24TE2emjmHL+lORJmrWbixB1wbGHpBrmD8dr+WljOEby7t7RZVNmM7j+7OplZy0iuD+XHBUId3zLlErvh/zc+yQK641+02Qe9fLc5LOv8/37hAxIIXOxpUqOBpmYYQSSfUllDcArHqi1+31eHh8ZtAw19s8xRmp7gI/z4Q33xw9ZcxhgKlKIAGNAsvkEfO0KQgpbH/xKr+kOd2fY3iGsZNl3uZR1TylKxUXBs0gGCd9vRE2sImpPbV3Q9NLEHKHgKgeJPxoS6FcD8E1uSH/gUuQ95pGSJUsaotLL6lIZu4nD0KrYQck/K4fA691C0r3k3ek+nl5XQXVK21imhGJFJGxbYts/drLROSzh7tRBE8uDbtWAVP9vFUBihh8OGFpGrBZxdbequNe+PgEUO4pQOBIHj7KxDcp0DK5JBoo/1I4TBaoKfaoyp/NZew7SDPUz0N0fMBemRarg82/iMNyYWlopY4KbZZZKzF3fmwhmAzCTz6xIUUty3GBpG0uoqD5MPdOYV1c6iWDnRhpztaVnUYl73P2NFewxB14PbmNIL+Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>


On Wed, 24 Dec 2025 15:50:34 +0800, Baolin Wang wrote:
> Hi Andrew,
> 
> On 2025/11/28 15:01, Sahil Chandna wrote:
> > Replace hugepage boundary computation with ALIGN() helper instead of
> > an open coded expression. This helps to improves code readability.
> > 
> > This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity
> > to use min(), after which the boundary computation was updated following
> > review suggestions.
> > 
> > Found by: make coccicheck MODE=report M=mm/
> > No functional change intended.
> > 
> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Suggested-by: David Laight <david.laight.linux@gmail.com>
> > Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> > ---
> >   mm/pagewalk.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index 9f91cf85a5be..9fd59d517f37 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
> >   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
> >   				       unsigned long end)
> >   {
> > -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> > -	return boundary < end ? boundary : end;
> > +	return min(ALIGN(addr, huge_page_size(h)), end);
> >   }
> 
> Please drop this patch from the mm-new branch, as it causes 
> 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging 
> when executing hugepage-vmemmap test, because the program falls into an 
> infinite loop in walk_hugetlb_range() and cannot break out.

Good catch! The problem is that ALIGN() returns addr itself when already
aligned, causing the infinite loop ...

> 
> This patch does introduce functional changes and makes an incorrect 
> assumption that the 'end' must be aligned to the hugepage size. However, 

Yep. This patch is not equivalent to the original code when addr is
already aligned :)

> this is not necessarily the case. For example, see how pagemap_read() 
> calculates the 'end':
> 
> "
> end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
> "
> 
> Revert this patch, mm selftests work well.

