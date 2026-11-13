Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2604606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=isCaEMYN
Received: by kanga.kvack.org (Postfix)
	id B9FCC6B05B7; Fri, 13 Nov 2026 00:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FE36B05D3; Fri, 13 Nov 2026 00:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A17186B0628; Fri, 13 Nov 2026 00:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66EAB6B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:46:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 621F41A028B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:46:05 +0000 (UTC)
X-FDA: 85429009890.30.F09A00C
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 31C33140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:46:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=isCaEMYN;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794548763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4rRGE+RVmHQmdWS08eNxSiiu1iRCMHoWjayyFspKz0=;
	b=CLloA/Ko1rUYgINu4LVnpqZM5oMhyOrOygdi0cw8y6+1EplIBr6VOengQpTpiNx9BY5b+T
	NoMHok9KHS+k12xv5UGKZPJNSdyEsGJSImTwwpB9RfMwHMTM5FU1o6b7iMDWIyuqCuyhy9
	jA6YcdOZy7oNeg3DqJLXNvr9zcSEzWw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794548763;
	b=woexHnUmd99DIQAUfqIGBIkx0rE8mjs1mUFeCVaG/l+6w91Ej8z2+ZlxpzwJ2iK4OETQ0q
	m4W5gqtvR52Avwc41n7VPVWES5Pv/ZfStXtlgJucslziC805pEnZyt2W+mrliv8MARKXJr
	JIbDphpANv6o8/agTH6yqyb9rlkPypk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=isCaEMYN;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91c1f548f87so11888916d6.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794548762; x=1795153562; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=v4rRGE+RVmHQmdWS08eNxSiiu1iRCMHoWjayyFspKz0=;
        b=isCaEMYNA/nCsCK3MFeYeVzRii/z/VES8vy43Eacsk2AAeiYvQ52w8pEmfzPTONDND
         qv7ZgJ7UkLdKxjJG9q/dVq25OJnuWcx16xgneD2ug3WK7gCXM5FzD2wLzmPKNvt9TXBO
         E/U69rQPN0xgdlXRh/bR1LFUXhQUheiPVrd9TIlaPxtlawb9b34uJ+cupYVnuXmM7ZPU
         28PCLKC5ir8hdXKHim0frT8Hl3lvHP+7rO31mirUSxN2Ca0d9D3yY9IB5dllo0zkgjrP
         todN8J8UV1jIbWxaep1AuwOZb3cU97s0DEJOV8ro/cuIAkOikh072D44eUBf9FE+mxJn
         pgPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794548762; x=1795153562;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v4rRGE+RVmHQmdWS08eNxSiiu1iRCMHoWjayyFspKz0=;
        b=WmyPvCXOE7Yc189OtYtkx/UqFbx43+I3epU6/7bqgnEfYCBRHyjKS7gjrk4WmPbdgU
         oE9Co2SnmviWfwHWCBqpsRV7xl5z3w2UlA6lB9NICT8KXaKs1Wum8olTbRKKLKM1swgl
         yWxUhJr9W2aIX8OGcHnQJ04QpfwBsI5jmojgm3oSNyTRl9Dl6jdrsNcY3S9NM67Q87QO
         7h7xRjq9cOQTKU9iNA2HD5+7TbcZrEf08BOhwBItRSdmt/SuoRj7im+Ov+Li6j0er1uA
         J6HIkbvfyhlU2JDmlTvSOAJrIkGo31ZGBsDafk5Ga6CVs/fO+nwLQBngUPCRWEgLfh03
         Ep0A==
X-Forwarded-Encrypted: i=1; AL+hErHYoMfluyZZJDgNK3n7Exw1DiOHcy4sKcfyI/RTHq/QYcb9r+L9yesyniwQnI3VrP+MUj3pa+ldfQ==@kvack.org
X-Gm-Message-State: APuU4Z//UJdyjZmwRcvGcMfeWhc1aip5dEwtMiNq1zllan+EXef/qMd8
	9uCYjqwKhysxM6F9wB3sAs32jBbTXhPOtutkKQtwtoPSfGpz4/VWmzECQ3Jkc7M1xqg=
X-Gm-Gg: AYBFou3qnh7VYkKR07tdAvCMWe60ZB+UkRyjHFj6qtMU6pWy2Fs62HkCur/FYbJ36Mk
	DTGD1XwYZn3DuFJYjWSsqSKVs5BQaEERIkgSlbPq24s/zG7fkZWB2UxTr8o5fuUrnYXdHghi7AW
	UhIu9bnyNr6/33AYNg39x9i/KWOEVqyjM2cLXC7QhV8rm4PQQS0aixHSq9WPHaOLBAyXlYFYjG1
	J2LMGVMxNeyArySxYaRVj0SUXmlsG8FXfnX5Xn/2PGDoaNIZwYA3TX6YwIL4udPHwCoKYL/ViBY
	9dFukuH6aXyY3WsEPmllXttVtrje3cRSF+vK5Z5e7HCv933PV07ye/iwVmXKAkJyDQCoc9jlHFv
	RaRvRHELUWHlqTqsstfAjaUxXCY6O9XjNjPCWjDVK2dZ1mMopVsJ2ABpcK4VNT6ITI26D4ZPNuP
	4aPy3TrvyLuW5FM0aOGxIM7ekr+mxIEjuk8iQmLJ/VIY1x3BucRADZIKTf0x/OEYc0zLNHA8AdF
	PgZ+zM6HLQBMVg91ykqugup0e0SFhFNzYxVARMEcRHtIq4EIkV3p78FgwOgIjyCe0fjSWuz2XMY
	Ay0E+Yt4n2V2d7YxyX07UuBTO7EMJgO04O92S/RDKoDOJG+lA8OsyHrjo7mhZh+IrftbgRUtESk
	xIUWFIhM=
X-Received: by 2002:a05:620a:801c:b0:93e:c12c:fbb7 with SMTP id af79cd13be357-9494bc76c5amr274209085a.68.1794548762215;
        Thu, 12 Nov 2026 21:46:02 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836f6dsm108597885a.22.2026.11.12.21.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 21:46:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/12] mm/mremap: resolve uffd state when the context
 is dropped, not during the move
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-7-00713d368976@columbia.edu>
Date: Fri, 13 Nov 2026 00:46:00 -0500
Message-Id: <179454876058.482102.4630783467113971871.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: yx4h9z4pb1ge667aqqu1wr6bibw6nzak
X-Rspamd-Queue-Id: 31C33140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794548763-690132
X-HE-Meta: U2FsdGVkX1/9AHyfNvXqPRFCJDSipoMyEPb960OLLD8RJqfjeDaHNzvJXHuLbYBqA31PQYZff8dTXZBUBfN7+mIaMWGfAG/8ql7C4wfcpBl1GRX7YESDQ2BVK36RwQA5VbvSwE3gGZL1CGLNTqphfQURqIKa1dujdNJnvDHC/w/IQvMtzHHEE/KZs9Q4FkZqNOmrja8KWkqz4AajZHvNJJiNzhMjtVnh5rzRtCx4bC2u/mRI30LtDy3dm0AyvkV6QP65V6aVVtHp8we8e7eiWaOUiaYisZ4AY9s6mvUElkl+MnPERsSLp8N6/7kAX5930OLFEzewTsgh7PgOcdUBMWBx+bvjZK3+g+iuHidcBtNP9ZE6cdwllxo89o1HhDbE3kbKM0o9qguSEH0qsfI+Kxg7wDQS4ff4PyVLMNlkMomTUGKUnGUCZ5ByPIO4OJI+Ya+d1A3JcOd58ZZ1IDRpHDp/EiG+tEHc3LM1kUjMW8Iac9YXiaPg2ykwUUy9Qrwoh6ToXgOq/lZrK7B08IxAJQ6JgofwULS81ImtDDMbsyo22a9dUJDV5nRrIEMh57DsFkRzJYkkY1IrFHF23vGceQZSdnSGmqNv2KRbnswstblYIUn1bp3bVDRZx7yu5nunMORCsNBMFyXs8jBKajA1Wv2xfmMAOW/ukodAHnirsUvttSJCsX+t6Hsr5BTOj+KOXIAwQyjYxiUa5F1jDC7Zbjt6mQKUmLG/EJOkpbyoOXiyX/qg8OwtnrgsOZlSNscCFhXwVeCKV+3nYWFoohC8436BbaJzArLeAQ3cdH0L5Ptpd5rCp4B0cqPpZUnvdgm/5/lBq51dMRV13mtfRN0sVUDaedXrEyi1LIVO6JefbT8E0CcII57Z2dkhB5Me+nDmWLJSJmyZ+Drl3fyyz1w9gGWpea9jHzL2cByNrBBidn6/EqLIsffVdN3wynAmbItNxPpR03g7fk4o16l663o
 c6pF0xvk
 BiwPwAarmyGAddkDD8K8MBc0YM5fh285DK9LELE5Ryqs8iyJcf0gSwv9XcL24757td7g+31lNNy5wkKsdvp+D7NyLYXtE5C0uzguEvrwvYuOLmfKIvC5whBri2E+8XfmQxlbEF8OSs+f1xJFnJ9/Mn2jX1EgLDKLYgBxEbBHYigQW8+B40EBGue3re4/XgQ6l9aniabREnIp7k5rwYT1bOhLoGA6o69z41Q3kApGMItgaofX+cOak64vatUHkXYflkTfPvAiMu7cB6GqkGJWv8Xsua8lvA+dQ7n6ug455o42ClJ6jOakLPleTWqPunWhQQr/yqO+wBmAH+TbRp6LN6gSSrlBYsPx45GODLuhaHf5UMFCazawF/wcWi3ezy5sCJYxp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
> registered with userfaultfd: mremap_userfaultfd_prep() drops the context
> from it once the move succeeded. The uffd-wp bits, uffd-wp markers, and
> RWP PAGE_NONE entries in the new VMA must be cleared as well.
> 
> However, move_ptes(), move_huge_pmd(), and move_huge_pte() clear them
> from each entry while moving it, before we know whether the move will
> succeed. If a page table allocation fails halfway through, mremap()
> moves the entries back into the old VMA, which is still registered,
> without their uffd state.
> 
> Writes to a WP range are then no longer reported, and an RWP range
> becomes accessible without a fault. Nothing restores the protection
> afterwards. This requires a page table allocation to fail in the middle
> of mremap(), so it is rare.
> 
> The uffd state must only be cleared once the move can no longer fail. To
> fix it, leave the entries alone during the move and clear the uffd state
> of the new VMA in mremap_userfaultfd_prep(), right before dropping the
> context, using userfaultfd_clear_ptes() like unregistering does. A
> failed move then puts the entries back as they were.
> 
> This adds a second walk over the page tables of the new VMA, for VMAs
> registered for WP or RWP without UFFD_FEATURE_EVENT_REMAP.
> 
> Like unregistering, userfaultfd_clear_ptes() also asks for the PTEs to
> be made writable again where that is safe (MM_CP_TRY_CHANGE_WRITABLE).
> The old code only cleared the uffd bit and left the PTE read-only. For
> private anonymous memory this saves the minor fault on the first write
> to each page that was protected.
> 
> However, this adds spurious minor faults on shmem and hugetlb. When
> resolving, change_protection() rewrites every present entry in the range
> with vma->vm_page_prot, so a page that was writable and not protected is
> made read-only, and its first write after mremap() faults.
> UFFDIO_UNREGISTER and UFFDIO_WRITEPROTECT already behave this way and
> lead to the same spurious faults. This needs to be fixed in
> change_protection() and will be done in a separate change.
> 
> The entries no longer need per-entry handling during the move, so drop
> uffd_supports_page_table_move(). Where the old and new addresses are
> suitably aligned, move_normal_pmd() and move_normal_pud() can move whole
> page tables of these VMAs again.
> 
> clear_uffd_wp_pmd() has no users left, so remove it.
> 
> Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Is this a fair summary:

"""
A page-table move clears uffd state before the entire operation succeeds.
If an allocation or later operation fails, the protection bits cannot be
recovered.

Transport the page table state unchanged in both directions. Resolve the
protection bits only after the move and VMA callback succeed.

  ... details about spurious faults ...
  ... remove clear_uffd_wp_pmd ...
"""

Anyway, I was able to reproduce this reliably by injecting some
ENOMEM failures, and the change looks reasonable.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


