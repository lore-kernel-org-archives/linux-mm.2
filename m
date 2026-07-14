Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75010C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 02:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6139C6B008A; Mon, 13 Jul 2026 22:46:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3006B008C; Mon, 13 Jul 2026 22:46:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465E76B0092; Mon, 13 Jul 2026 22:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18E526B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:46:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36FBB140211
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:46:33 +0000 (UTC)
X-FDA: 84985843866.23.76C0609
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8DDC440004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:46:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mClcqMyN;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783997191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAQHSDx5Pf+w4+v4uxcesiEVqlXwwknrma7QzuTbLYc=;
	b=mdMQHYwTXlNGF2PpSwgLEsJzjO1cEs7BW4CGGcGBFttAcDL9lIDKYt7iWgCN42vImiDZnJ
	fJDZKvd2gEeFB45D3PTma30yIvu7Y40ZNFWmQ/BAEZ+sOGLRxDdxRN6ZgkR27JGDcbIRL5
	SfCs35J+aitX4JhzeDNhrJOE0hS5DdU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mClcqMyN;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783997191;
	b=z1felsNbpHcP9wXFNVbRuTvuMBUaZ7Z60eSGFw3dBFlshfYBOln1a2H4PxVfGIBzQkevxe
	5SSfvCXdKQHzmbGHE7/nS0PVfGVsH/msRkP70jJnvoGuqJdbYJJ2WxpzORn7ss0RGiWOTw
	L5MYeK5Xm2spPVgPgT1TVrTIytWU0AQ=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783997189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EAQHSDx5Pf+w4+v4uxcesiEVqlXwwknrma7QzuTbLYc=;
	b=mClcqMyNV4sFTQazeEiZNF5uDwQLQhez8hYB4lH6ijsXHxaEdK7XG/mIiCfJdQb7RPf5bd
	2fiOxABPjI7E2jAbl7eAiY6MNJnUN6xTLjVE78wHQmn1D6S5R7TOBzUqy6H5uXrahWl0qB
	eNc/y8IWLJ9AhDmXEIBwS+W2nimHfKQ=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6 3/8] mm: add a set_page_section_from_pfn() helper
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260709112520.24857-4-lizhe.67@bytedance.com>
Date: Tue, 14 Jul 2026 10:45:52 +0800
Cc: akpm@linux-foundation.org,
 apopple@nvidia.com,
 arnd@arndb.de,
 balbirs@nvidia.com,
 bp@alien8.de,
 dave.hansen@linux.intel.com,
 david@kernel.org,
 kees@kernel.org,
 mingo@redhat.com,
 rppt@kernel.org,
 tglx@kernel.org,
 linux-arch@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 x86@kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <ED913AB8-0DF0-4F2B-9E7E-ABC4BF926C9D@linux.dev>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
 <20260709112520.24857-4-lizhe.67@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5snrjshyx7ri7rcjgk1u3wwbsuq3ae3a
X-Rspamd-Queue-Id: 8DDC440004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783997191-466196
X-HE-Meta: U2FsdGVkX19fLG7uPwiHxbWMPla9TOAwp4WS7XOZukDdIIxr6tNXnebBC9BjpLZGIdIuuQfDkcbo3v9uZKczPX+fUMB0TJySa5BCf2eBbkXE7XpSTpDfyVvW3J/hZtUV+Efrhzm0aKph8cOjJWlKj5AhXth9DOYTv4+vLBD6Xob114GGm0BDVCsovM7O28iq/zbKyG8MZtBrRcPeHDxefsaPy4lj+wz9FbKeyQLWUcPIBzCGOjJ3rL7Qt0+lvfsE6n1mwr6ujhp+sqARLki2czhSW4jY3MUOiq1+HtMeNvWv6rbZd9LElQyZYNhFUN3kxCbYMdLelsAYgVE48S6oVyDT+UVMUNHA/orFW1ngjEmBs9RFR1OYxamDZE3mVu2VLig7aTIhnqDuAKPu/5oehetvrDAlAiPy0iaqGTntqaWGiPbC87/Cl1al5EX/oyCpGTi29ZzYeEI6CSx3MeCwl1XAaRb0gv0LzvlhTrfLUh8ovX+Bu10Q5uK40yncsxt/sRdJx2jiZhIxJhHQq0/Gt5B0h4I5oRXTRAMYnG3IXH+dETN+oDhDjlhLxTmABRPkerXhgCn3blG0QSt42g4/ypdhhtcYjQYnk3FmMsaHUYb4GGxkEGDc7YDhnf14yJsSU7P1u7sZhBaMRNETcwOcm4uXnJuPy6WZC1saKBZm5tDuUpsyyGOvn0ftpNhlvUGutO/xw6QFt21N65IiKlju14RbNdohFymd/YrwJX6ZTnKvNQNpjuyjsr6l98dgd5uipNq7wB6Wzr2AewxScm3wEoIPvj+WTvOV8hXw2FQS5pw02Qu9JTPHAPiAUAq+B3oAJP2t5PCbP4h7Rv+bN5vKnL/mHAEatijdwm7HIq8N0lSpynW+rsRMlTtCeQV83hq+tPI1yQTk5f77od4WUrx4WS4uqxb+kP6/UGERYkF1dsceE2tcdmrC33r3vEEmyIfIqJ0dnHtuWdEc+VmPMWy
 16K1s/BC
 HSQIU/QchKT3o38Or9cBwkeGEVDJB8SH5EGSFCuda1yvh3M5issMixBFICEi8mM3N5n2NY44pFnb8trhqAwOCcnWS9PzYsCJhLLWFbVjkVaJcNny3jqv2xkzuhDk8buY4xsHBTQibuwEc8RapWLoViOT+2cRiQmH3HP2e2529qPtGJTiislNvZHylNPlOmyhHvqcYfYe7j9gF3cEr/uoq8KF+gFOA6AQjLLVZeKndRYCBSe/SvikQEY6AbxwcYd6YiG3eHDpYCX+xDjDGQEmSm9Zb0d5GJi5peRmvls58Nahcsp3BxuOo3fDFY0gTfi6bMbYDlvlZvl2+e80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 9, 2026, at 19:25, Li Zhe <lizhe.67@bytedance.com> wrote:
> 
> Callers that want to update section bits from a PFN currently need to
> open-code:
> 
> set_page_section(page, pfn_to_section_nr(pfn));
> 
> and guard that sequence with #ifdef SECTION_IN_PAGE_FLAGS.
> 
> Add set_page_section_from_pfn() to wrap that update in one place. When
> section bits are stored in page flags, the helper derives the section
> number from the PFN and updates the page flags. Otherwise keep it as a
> no-op so callers can use one helper without open-coding
> SECTION_IN_PAGE_FLAGS.
> 
> Convert set_page_links() to use the new helper so later ZONE_DEVICE
> fast-path patches can also update section bits without open-coding
> SECTION_IN_PAGE_FLAGS at each callsite.
> 
> This keeps the PFN-to-section translation local to the configurations
> that actually store section bits in struct page flags, and avoids
> exposing that detail to generic callers.
> 
> No functional change intended.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>



