Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BEECCF9E3
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 01:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF728E0018; Fri,  7 Nov 2025 20:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FA08E0006; Fri,  7 Nov 2025 20:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C476B8E0018; Fri,  7 Nov 2025 20:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB2B68E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 20:44:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5793416061F
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:44:31 +0000 (UTC)
X-FDA: 84085745142.12.A784D95
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4733E180019
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:44:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1nM47f+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762566269; a=rsa-sha256;
	cv=none;
	b=ZWS31IwqhECenuksPJ1Wytaugy0/lWLclz1Yri+uVwUJARNwboM657ZSGAwawPZMDksOaf
	qJmWD1mYIqGNp8jJD1cxqbKgvlh7vmTfsfnG0LAQ08yZDEY0lPjhBi59pJ1nHFNFaiwKo+
	7vRhJ3qxvVoRpHqPt5fTerx38GQw1HU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V1nM47f+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762566269;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHGSN17jZMfxWvKzapCEmQ8MEhEu5sMdAfX0dihLnKo=;
	b=eNg0Gy+BYTndqC6hKzrXxrNmVFR9mC427J30X88aKlzpqk2IqCjgl2gd/lzMRqsVV6xSQB
	wHvibKz/t5HiYSXfKVKMqOqLbmuztkFnPFDo95o/555DBohMJbQe/wHKsZlOqQGq9Wbi2d
	I+DRH0Ked8eem84r5Z6RWIzGSjT7DMQ=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64080ccf749so2220243a12.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 17:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762566268; x=1763171068; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHGSN17jZMfxWvKzapCEmQ8MEhEu5sMdAfX0dihLnKo=;
        b=V1nM47f+mLSO4/HbQkt6JABG6LGZ1ZcxAgHu47ia+L82JFYNO6lAeU6kJNPWDzfajG
         X/zrM91DD1d7bRbkMcuxB4zztiVZj6/K+Z4MF19h1ufigJBKC7POUwWhJKWkyVXORqER
         g8sK+87wbaWxQOajSrOU29jWaDHiVbsHbME5eJEZZAG9fkP4/1ygQIlJNG1ik/YdqL57
         SEm9FR38NxNGXmWieo8yiZrMvUIhgZtxmI3SU+9Zbv1RzQZEKMioavn3f5FJR4SsD1wh
         +v3iIw2b/E5V1CRm/BKRiWd9eGVOzhH92XFKzadTDL8NH70IWwct6cXap3a2uhuu6Q6Z
         PntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762566268; x=1763171068;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uHGSN17jZMfxWvKzapCEmQ8MEhEu5sMdAfX0dihLnKo=;
        b=hgK/K3ugeAbumH3soSsGfaShpi/KF+pyf8gBy7yuFXSqPgCE6w0hDaLkcFbb2owlIs
         BFegmzN2dkh68aJvGhb4LI0iZvJaKVw3is8jbUpSUWWKxA3wNlYcJlyVMvNeihFDkbI8
         NdtNYspxuF5AJP/lqoWOa+xIG01MCbzLCcVvu1bODXge4MWq8+GNwLQxuKeeNYqJunsI
         i9voND+M8qCmwNoHVDlyvHXIQZnEBg2LslnmhHg+5ODRgCSQ+3VXH07aICulAXcWIr8R
         /P9NhykcXFpjk594133ZFi0JbvQIgDDNenPNCzjK2J7k2AuvJI+qnCmMZA2gssnw9ZlZ
         4Kzw==
X-Forwarded-Encrypted: i=1; AJvYcCUeFdMimghRDbYY3YrGKDbSsvpnqTruYTOWvlB72gjOhqxntK5zqpJBgFqEo1ArytFGMzeTi1sMQw==@kvack.org
X-Gm-Message-State: AOJu0YxS9Gh87lgMFWJLBjSfBmQCj2VpKagVCQZEOXZcxeSXocBm6sWO
	mEKY++tAPtu5iA4AA6x2VbgrmW0Ur0tlaWIbo9g972tLZEoVGIisN7BpC/uelser
X-Gm-Gg: ASbGncvYXBX1z86ER4YkN4YqK141RGhsfYbIE26x/xfa2Wu9Chnw/crK8CCHl/jimu1
	ziyaNXiJNvOPI4JnNNxCUyEE1u6LXK9CtNMHr56sjHKPVfcbzLvJFZdiK8vvMMazHji0VqNBYiY
	331UBAPcLXx0i+jU1oQ/OSwihcZ5wa1LhGM9av9IJaYFJjco9WUs+EGUdj72apRLEMZKWkNTK2V
	VaV8xa5CSwjaqDijAWJYo9c4eZXdtvJ87ncN+UlEWpqlgcU6C8QYB5frrcXzWqcEOXG3v6y0EOp
	VCDZsimTPTZX0s4PfbTeDzwWJQ5481AF00KmjOLimxY/6TbUMyEHtKI2i3XNUCDkkvKNywfMGER
	OAN5TN5g05Ez5dNEj2jSHHxgNNIp1/OIca1YrfYX9L0bBKLjcwflK/GQi0BwvRGvW6DG3K5Yz1H
	sijuc2pT/lbw==
X-Google-Smtp-Source: AGHT+IHhwXLk7xWiTIAmHwBxke3RFdw4hY5rd+dV3nC2lXtWeKTLFKd/7oouP3Wzzn4re7c2VoD8dQ==
X-Received: by 2002:a05:6402:524f:b0:640:c454:e9 with SMTP id 4fb4d7f45d1cf-6415e5cccfbmr868352a12.4.1762566267419;
        Fri, 07 Nov 2025 17:44:27 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f813eb6sm5471242a12.14.2025.11.07.17.44.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 07 Nov 2025 17:44:27 -0800 (PST)
Date: Sat, 8 Nov 2025 01:44:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 02/15] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
Message-ID: <20251108014426.5lwchfsvgkoo72fc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-3-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-3-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4733E180019
X-Stat-Signature: dj15y6ajjt3fusk3ase6mgboe86w54yn
X-Rspam-User: 
X-HE-Tag: 1762566269-566895
X-HE-Meta: U2FsdGVkX19Wgjr9mDh2txlUjz/LdeuWEoucv9KmfiVS0I7lgKbhnuZldwSUQ3c7WQaGr70IoiLQRwWYMvQZCgOCzxxaXq19jOGiTQC9G9PqwOCQxf0ND3IiTlFVQYhR4BiqU3iwfIkwziuUdPf9dm2OO8W7vZmzsZTjtoSFdMHDsadwTwEWvGEiIp5Zrj8bsStL9wPFppoyE8fvLvVMuhZErSnZN+ksg9FbSfWE2J/5whZH7CK8XXon2wSFaNGnP8ClVTRMEaNwZ45fikn2CMN/GI9Q+Jh/WeytAuNgwgFkORl9NpGma33LIFacODt/hinaAkxI2I7l2DjC8DLJ7LP3sxA5XH4LIgCN4foAInBDqE+T5ud2njZkOapT4RoTtHdtnHe743PWIk3s0tPQGV3wdnA4jHL4ARXyrdGtunkJMiV+m5nAsWECuGwYCGbjeiS+ABl+mrfx+77T3CNXP23FR5NddXKCM9uK+Kxgwiq8mBqZfyFkR1oX5U5aRGl6xZKW7thfYYj0X/olUaKvubV162zlaDu5bArGSmlCk1bAI+o3iY86i+GmOluwozRb7NQmsJbTmI7QJXtufb4elHQwXwvNQNXh9SfQRX4GhcBSpxCS/6BtIgo30wBHqQt9Parup7Pxi/Di5e6ht8//EWk+yq/vRHmtyaNtofVafPKBOpyeWKxjS2wU6onMSOLbuO16vaUi3GlE5tXvRWNgMNenTnpZPDAp1OeduBO9WT2TsRUaQWzDmYyq3LpnH2Q6HY94alKWfqdynttw3Jb6CJB9eU+vSJQoSriUBCw5dZT8rLXuTCl2a5CO3dytaRFK+dxj0sJwxJ0EEKdlqa9QDo3pyScuO/vh/cdclClbu9x2CMwj1C4RCyNTdWFUFc/UO78peS5OJ3mPVIc9MtZRqth2OlGFtm3X/nrVrVl84CH4TCagJKnaN1ARcA29xM9FBrf/Iez2qlVirE6RldH
 aE0ILYKr
 aVZfkR/m3duLnZFY+DtpNsiOS56OZ8mfGGdP7nd8OlRmEI+Ah8uwhemsTkvrRVjaLGLepfWPO41qXPNdWEhRIvBq0ALwEVpyNmf2OvlBFVhjth8KeG2PclU2x6jcf0XKZx5LmRClRFsRSDGDcOPeQ6CDnd6kJC31EIcXONk3Yz45YX/N8r3Sg1ig68vdHRvNSppwNHCfLBY+LfTyYI5N0o22UKRyuyJOIkDXwFIA3akw3DAn6iBvM7NrQqtHqJLAcqpUqNSM7QG4cUkxwLK7uVdT3obu8Ub27csuo9CtZnot+xtyyeMCPpfidCzdecLmmgElhH3YHsJAtznQrLEeKDvRWoNlYnXe1QX0t9w65EZPQX6JfHX5OVZVas1uz+bWZ2fR6k3uOpVo9rMg0ZqlaGUhfi2MSS6dnvzj4IKwSo21jOdeOE2+/oWw4Dje94BH+XiKxV5sXO19d5SlugxViMaT2EqmKgKX7g/lAWi8nwjkUgXG14jTM43iSMZPfvQLVwcrQDjADYUfhV0Knq0VTaKqeHr0uZzFz1Qj+WwlpH9LzZzNeoib1lwODQQOmPYD4qh5Yhq4zEi4yVtGOiP4/CgWC+7mOIOWzR/GYsaOPdxAPk7TAmIMmPJOkNdGOYCt6qFZv09/2us5KTnWALf7OEja9MG0TXIGnkbWa0xPxISrda9GolFZ7SMsjSy5IuBZvY3ZoT7tirxSNnduvu9xEDr3qFvVXCB48/3XsmcXELyzlr8C9dfFSfgIbYp/vvWKGZZ89OE6xW62p+pKWyB6v1nT+gEiCE3J3KfwMpz0ohYRvc91y22n40V+iuFzcIsdZfKnj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:04PM -0600, Nico Pache wrote:
>The khugepaged daemon and madvise_collapse have two different
>implementations that do almost the same thing.
>
>Create collapse_single_pmd to increase code reuse and create an entry
>point to these two users.
>
>Refactor madvise_collapse and collapse_scan_mm_slot to use the new
>collapse_single_pmd function. This introduces a minor behavioral change
>that is most likely an undiscovered bug. The current implementation of
>khugepaged tests collapse_test_exit_or_disable before calling
>collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
>case. By unifying these two callers madvise_collapse now also performs
>this check. We also modify the return value to be SCAN_ANY_PROCESS which
>properly indicates that this process is no longer valid to operate on.
>
>We also guard the khugepaged_pages_collapsed variable to ensure its only
>incremented for khugepaged.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Acked-by: David Hildenbrand <david@redhat.com>
>Signed-off-by: Nico Pache <npache@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

One nit below.

>---
> mm/khugepaged.c | 97 ++++++++++++++++++++++++++-----------------------
> 1 file changed, 52 insertions(+), 45 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 6c4abc7f45cf..36e31d99e507 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -2370,6 +2370,53 @@ static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> 	return result;
> }
> 
>+/*
>+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
>+ * the results.
>+ */
>+static int collapse_single_pmd(unsigned long addr,
>+		struct vm_area_struct *vma, bool *mmap_locked,
>+		struct collapse_control *cc)
>+{
>+	struct mm_struct *mm = vma->vm_mm;
>+	int result;
>+	struct file *file;
>+	pgoff_t pgoff;
>+
>+	if (vma_is_anonymous(vma)) {
>+		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
>+		goto end;
>+	}
>+
>+	file = get_file(vma->vm_file);
>+	pgoff = linear_page_index(vma, addr);
>+
>+	mmap_read_unlock(mm);
>+	*mmap_locked = false;
>+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>+	fput(file);
>+	if (result != SCAN_PTE_MAPPED_HUGEPAGE)
>+		goto end;
>+
>+	mmap_read_lock(mm);
>+	*mmap_locked = true;
>+	if (collapse_test_exit_or_disable(mm)) {
>+		mmap_read_unlock(mm);
>+		*mmap_locked = false;
>+		return SCAN_ANY_PROCESS;
>+	}
>+	result = collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
>+	if (result == SCAN_PMD_MAPPED)
>+		result = SCAN_SUCCEED;
>+	mmap_read_unlock(mm);
>+	*mmap_locked = false;

For all cases, we would set mmap_locked to false. Not sure it bother to adjust
it.


-- 
Wei Yang
Help you, Help me

