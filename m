Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D7DC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 20:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0ACE6B009B; Mon,  4 Aug 2025 16:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2AF6B009D; Mon,  4 Aug 2025 16:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF85E6B009E; Mon,  4 Aug 2025 16:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B28B66B009B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:27:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F18115952
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:27:49 +0000 (UTC)
X-FDA: 83740211058.27.44C4150
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C5D420006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:27:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcaymQRi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754339267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ns6Sb1qyWQLzllKTByzLhCTEnna45qYiaoa055hFWgU=;
	b=v1OHDlbL0ehy5w61SHDsszpNafWfcMVa34uAynn3sarV87e5H8r7DfoIl+DJESPxMZezG6
	dWMz0wmVdhqkonk3jgQiZJDNoRiDwZ/9MyubRdBNl7LIkRoDLNlzxzD0m77+XXjQttRvV9
	+G67tYIABWVTDqoHvxhJPyMzZ/OPjFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754339267; a=rsa-sha256;
	cv=none;
	b=gpCFaDY2cM7beIY2Sj+3vF14pl+LLyEPcXiBxDkQpWsehpdPD62YBbmW9tPtFVnt7pr9cz
	CXYjJAZQNA5l6MF9o9R/xYHbJ9XPvZ9w3Jwvboaod1emDCbF8U4+72C3CwS5f2u+Js/iy7
	z7MH5pHf4VQ8dBVUCB6GDzhF6GHz02A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcaymQRi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-236377f00a1so42188055ad.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 13:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754339266; x=1754944066; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ns6Sb1qyWQLzllKTByzLhCTEnna45qYiaoa055hFWgU=;
        b=VcaymQRiS9QKMSFWZwzuyVy3uZKdN0gyjUZP2h7cJSXKngBG8zKIriKS/YEXAN3log
         FpBO/AudeXSv+PwVgVrmMqHyn3TJhS7Ajc6Uqn+mmBMVIrB5RvuL4bi2P7bqNYTNZnv+
         4D/LRBuKCN/8QKctFFSw1F+h5oOH7Pp/Ap1uJdGhfvbd6sTRQW68qh63ZGbMHvkc8jO3
         g2j8r94Ar3v65rrDF5LfjXHoY8fcHkykc3KULDdk68vaskFTK2hQwSRu69trqerucj+F
         /JkmoEeaXuVuSNPqKjgdRb0E2exyySPVKVUREdzxW72PhKwMWFBg6jECASxA0WhC1iRI
         fJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754339266; x=1754944066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ns6Sb1qyWQLzllKTByzLhCTEnna45qYiaoa055hFWgU=;
        b=msCm8DpvK+fSpPLzg2IFYx8XeS7fIFxmOz1pb97AMYzjYMhAjX/Vn2/yw7tKN/4IQe
         sB8tlmWr8+8hEuCS/1moC6tLcB5NTE9IdJLnjHfvlEJSE/R9yR6KHT3BDcADhF2G0Fbb
         tpxRAz4XIq6UdEJRF5AW4bu60kl5uAr8JCtYCEoomi+TN5fZe3uSsKEUSsXr/ye4Xwek
         QsQEAw3H9tpgPR/22YbSFU8gnO+8ij3AiVyEx4QrFh47SS3S11p/WlxBXFDmAdCxVvNV
         V5WnJ5Hv4fbcyHu/+Ku0OZt9KB+7qqkAIixNozqIEdiT2h05LImlVvDbzoU0wLtFahs0
         PPBg==
X-Forwarded-Encrypted: i=1; AJvYcCXktMkshUq0NYEvkg3J6Jx2izeQanUB26fcU7GKOBso9c8sB9YkuVHfyb5Ah3n06R44coQJuNx3Gw==@kvack.org
X-Gm-Message-State: AOJu0YxKFRSFeFCRmo1K7Yxz2OvO5Ku9ImQMFsXlI/UMAYHs1rSRSvVr
	ngMPIwGYMg1o4T7xo4MWq4KO7AogXKbrZpFN93UTjclFATkCrov7YVHQ
X-Gm-Gg: ASbGncvV3AWMsCjZH+R7Xkl/S5LABUNGiHlWuiPewVOgFz05qAQkwChRFVCmcK+Q7LE
	BXkjPUSWbkZxi64/U8AzeCppgWmB8dH1JhXBKIIYyx4e0gGGyQH4gAif2nIVtfXcWKaSH1xdaUr
	q1+bbBh/1JCkZl6/yIcrkMnlc5y7kcPf0iVE2i4ORTBve/ErWqu2Mo7d2H/ZEkqJrjbRlQOtuYP
	ObVKA0NSQSMz9sVMUdARTu6CpahNvdKWuAz9RrhgHFsz5JyNuGM5t6fbyI8YVtJKS5bpx1W5zyI
	NRePgAgkGIFIHPpLxtNJyT3ph6WKYjTADuSaQuXvrGveQpdfc2nNZLD5LzVgWQ8tJugS84SvwNK
	W22sbtF+jiXLpt6xPhk/YtbuSk34RzM/TjkmfJ7CCOW4QrBeh+dIIIA==
X-Google-Smtp-Source: AGHT+IHyIQYOk/UK9tX/+gcOyD5O9dOpWMo2wwLykoYYEPLIj1UeBJ8CeCuZTjz02csQNtIP+D73cA==
X-Received: by 2002:a17:903:2111:b0:240:a21c:89a6 with SMTP id d9443c01a7336-24246f58785mr112133915ad.12.1754339266211;
        Mon, 04 Aug 2025 13:27:46 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f13a31sm115567315ad.64.2025.08.04.13.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 13:27:45 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:27:42 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
Message-ID: <aJEXvnrvaoUPvD2l@fedora>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
X-Rspamd-Queue-Id: 7C5D420006
X-Stat-Signature: p9zgyzgnsofx3tw1o9y3x97hq6wch1p6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754339267-417499
X-HE-Meta: U2FsdGVkX1/LJWufXo1ECtzaF15w3baH1sVTXKrLRDXnBDIbhFCdVstllEdOwUVjIDaFrbY5USuIf+iGafMTqcfKHtaYl+QVxBLIeBgDiUiQ9gxW+CzdZlY6h2smzkGyOsSvolbGm7djPugHAzMyazR5i3S/hKQdTtOLd8AIyatPJci9tKzwtQVza9V1USmSa95ahJT4Cs5wThOoyz41R4ehk8ZDzVjs0rNC2VisEAlJrkpZu67ziVI/VJI2Q3Gx3UgHz7xZC9Kidr68Z6bzHSyAQv1jU5sfhYBQdkyVu9RxwgH/a4rocI7AToAQ7S2s4MoRU3xL7b33Dr+pKvitfKjZJ+jZpg8rkw2glzZ22jcjfEOU5JgQzFhajV291lVNywCZZLfCw7qJCax9FuNItk9MMN23MZhJRTpms4Ps3pzgXDv5rlH45VFeQzMLXYpO7AH7T1LhkaayztgJwtZYFC92Kf7Svsof5wlNS8146lNRNPnHOMB4M3jQFzniQbpQWK7IxOy/IrxZ7JDUZL2snCSKIlLpxdJA1TJycOh7gvdlADGCMVPzir3L/iX0zmOR14HaVRONlqwiPxlzznUyJT3lQ9QyjFekSJ/YbNsYox+E9ihSe9uS5BdbuMn/lYVs6G55AQ0KGnWuoNygn3kkrZD3b4OTx9x2EsTVkBWdu3WX0mVIM1hBR79a9MocLMrwadpevub7+ao1xyTuv7NXd+qnXwkEv1wMC5yjqHksmcAreUK6DZG50BnnADsSaZvQ5MM9YXna3VA7zrhHy+ckHubII3Gu5WJGQhsWuP5GdHrJzanCkAPvpn93MLdhl8lWUGSlMMtf33lPSOZBUosRWabjGvE+eN1KTLnXnOaf0PzMqc4ZqEYeZPHnAz8yY0oVYbFxLHSxgYNTS60zT5XsjySSnM5bAPA2tR7nrxBJlQfRiTo610FSQmcU4db+mQteOwpoLxH5mtyj/FGGc0g
 SVq6jAYg
 5UljeaNQTLABbyehqCK2LayTX/KzDIHZ4ywIobFH1Hlh39NynYbPspRzLYfYV/iEqCa8ulNkT4dEmXaO2ceyh/NzAN1qaFaeSy9pmnKERwO6G3VEuL+2YcuvlshEFxUYDGWAS0tXTrqv59nbUH8GT4mIGwGl+EREtXiyuwiF7lMOGmjTpmynr7LefLRXsUdA/9PjpMl8Jj74/NVaY45ZTUoh8kt0MNLc/QYqD0LRerqMN7ZgssY2sqWGXxm/crY8TdRPjDjj2oT8HysKytlYgUrRwc2StgqS9TSgoAM+Ur1JQJvD1Cu2AiK+iBhGRPXTHRcltmt+KMp1zadPazZ0BR2BawvtOHSAhTES7PuysI+CP4+GjPYctSB0AuYHcoVOgCVYHk/1/GjV/hX7AQXixsr/oVpHguO/Ylod1l9prE+9SnD/HjlvK65gXS9YPDGVhwlO/YY0M4iPZl5A9fbsHT1FojFEbFB9aS87UYFSKuJAS9nf/1FwQBWc7Qjr90DHeIjtC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 03:31:01PM +0800, Kefeng Wang wrote:
> Now alloc_fresh_hugetlb_folio() is only called by
> alloc_migrate_hugetlb_folio(), cleanup it by converting to
> alloc_fresh_hugetlb_hvo_folio(), also simplify the
> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
> too which help us to remove prep_new_hugetlb_folio() and
> __prep_new_hugetlb_folio().

Have you considered renaming alloc_fresh_hugetlb_hvo_folio() to
alloc_fresh_hvo_folio() instead? The word hugetlb is already a part of
the hvo acronym.

