Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7C3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 19:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD07B6B0099; Fri, 26 Jun 2026 15:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81AB6B009D; Fri, 26 Jun 2026 15:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998466B009F; Fri, 26 Jun 2026 15:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73F256B0099
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:36:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CCFEA05A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:36:31 +0000 (UTC)
X-FDA: 84923070582.03.4442814
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5FBED180003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:36:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n645MZTT;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782502589;
	b=KrYHKZsDgmXeiucStUGoB4OUm6xmU6UzttTfgJknLZS9by6I0EIUNS4n1b2j3yCnXINJj9
	LujyjkdBJRs/VTc2azYQQZDPVu7Ns57TjP2LLwMYuI8wTZoUd3/yLl1sRVWZa1B/Sf/C7c
	TQFPVolTeIiTK129tT+xqPZL5/uwruU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782502589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=20+N/oc+D35pxQ8jq82BbKUSx7bgjpt62vyol/ZQSjw=;
	b=A8T4hIpyW+Mb2gXfQt3eYBPwJPtkB5hDSuiitY+ZNUkCzYqRZ4TVXeDYumKKa9gViNIkZI
	sOF1a1U7HemY7N8+FDlkSiZQIUB+PrwkwoTD/xM8Hwe+x40vnVkEQDsyKhTu9+z2/d1l5p
	ua5OSBFBDPFhW55P83l0lVNMRKEc+Xs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=n645MZTT;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=20+N/oc+D35pxQ8jq82BbKUSx7bgjpt62vyol/ZQSjw=; b=n645MZTTLJSRj878uYMnS7Y771
	rpT5zmP0RfRwIaQN9tNcHkfVFJfIPxgzedflQOcfb6alHS0QPAmnx1tmYYNBo2Qz+Cn5NZezrbxc6
	IXd9xMgJe+kpSCVNxCdRGgZczAXkTpPwFZsslNz4SB3NsyviHoDSdL53uSsIe0LVlcwY9ndQC62+U
	EKXTkkAAD9fiZAcFAHoVQr/BKBtUAQhOBU8EIc06CkbxzR+k7heaS68qF1na/51eJ7gs09dQ18Cy4
	DXKXbnEhEnUintH9xWFNz7N0cwgXx6jAyD9e5MhCuy+gbx3Lbo5HxQc2nz4cerx3cEwKW1t0AVOp1
	R2poU66A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wdCLh-0000000CNrQ-3wWQ
	for linux-mm@kvack.org;
	Fri, 26 Jun 2026 19:36:25 +0000
Date: Fri, 26 Jun 2026 20:36:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: linux-mm@kvack.org
Subject: [BUG] PUD entries are inadvertently disallowed
Message-ID: <aj7UuWtZMo6jHfKU@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5FBED180003
X-Rspam-User: 
X-Stat-Signature: ednu1j5uaixh38f5w3kdfgrbpmy37tui
X-HE-Tag: 1782502588-15232
X-HE-Meta: U2FsdGVkX1/V86Ii1GFahhT8YBJk6Wy6DKfh+MQnkMp4YIEhCkq3xD6fYqNZBtXJIdWSHiO/hVDF1w8iL3KQQLvVYmth5myfbUVMTcBStV9UbWRfQXQ2CctlYaHeorByjPbK7sdyUMEUeVIy/d1yhXJ+k9ZYl0qeY4/IqXbfY4oAEaxvVXAwVhpjSLq8GVhP0AlmlRrr0imtmwqWGPQRe/GX6eIc4olx6N2hX5MRtOt6V14LNjcT/GgZ/9W99Wo+q0iUFcf4rp4gDUzI9NnMdf5NjzV8G+hEp3rSiDU3CYJ6G6KOPTIdnUWMAtkkrAfrZviQwczIy+XPto9jzZO9NBrL0RlMkDmg9s3uD/88maPhTnAkW8J8Ll7i9zDypL/hSj9PdtEfL1nRiu+r/NwCAJh881bJZYD8XK9jjOJW/d8AbboQJOfIHLEj+yEgcpxCAVxfCzZKviKGrcdb+IhYBqDLp9QgT5Yha3w9uxTH9MHvOeGVKxpdTl5kAbcHu6vb868H6koLzCAS6o88tifJp/uEoP66bJ3db0v1SIE3qSQd69+UcakfvsHFs6zlJXpWkxom/4kC8Rb3tT3XAnP6MP+br4F1qczNLRe+U0Huh/qoi3b35OizEWWVkTqmNfcZDpWC/6SG1DGbgXSZRubXuLUbOEnqlaoi/bF31DjSDPonWDBDAoJFreW/qM7/28/Gkk/S5iPWqDeB91g2pxnh84YycE/zMuZLMQTQ3OZPu6XmN5BuP0a4tztbTB0CthGtK5OGGwGFZAhw9fmIQSmoqv/Be5me8NrGW+5xzn1NSnJ9vjlTpZhoNhFRIau9fHT04zMqPBrei1hjrCwp0BGYitV0v193S4Dl0NpVeQbLLbDXLmWuuV0V1uf6IM3KrhR3RQuLzZLc2dOJ9Ei3o1dU41MyEYu6oNE+QohmJPwytluWCfALxedOsxouPC9BT5+kgfI+iNf7qYvVK458T4Z
 /REqSTuV
 vzGIRBFCNrgN4Fc26mIEixGP0PSmBesk+HruGEHp7ftvTxtt3wwQMg5Jo4o7mvg67FLBuaxbaZSncqwYkP3mO9j6s40brCE1TLjTqSaWAOwuEvQNJ3Q9dwjkWmgydYwSH4yodYfRKztzpi0RtAWha9/MxhORzXU06nDRtXsjy3rb8JHEP0u7lPm11QBvclK2I4CFAvCPsRm7/QqwSzZZrI5msw+G6ea3CKZl9vnUQq/A8Tlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I'm about 3 yaks away from the one I'm trying to shave at this point,
so I'm giving up and just reporting this as a bug for someone else to
fix.

static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
                unsigned long address, unsigned int flags)
{
...
        if (pud_none(*vmf.pud) &&
            thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
                ret = create_huge_pud(&vmf);
                if (!(ret & VM_FAULT_FALLBACK))
                        return ret;

thp_vma_allowable_order() -> thp_vma_allowable_orders() (vma not
anonymous) -> __thp_vma_allowable_orders():

        if (vma_is_anonymous(vma))
                supported_orders = THP_ORDERS_ALL_ANON;
        else if (vma_is_dax(vma) || vma_is_special_huge(vma))
                supported_orders = THP_ORDERS_ALL_SPECIAL_DAX;
        else
                supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;

#define THP_ORDERS_ALL_FILE_DEFAULT     \
        ((BIT(MAX_PAGECACHE_ORDER + 1) - 1) & ~BIT(0))

but not all file VMAs use the page cache!  Now maybe all device drivers
set PFNMAP or MIXEDMAP and can establish their PUD mappings this way,
but I'm not convinced that's necessarily true.

