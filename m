Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82B03606D814
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D6q3gpTp
Received: by kanga.kvack.org (Postfix)
	id 8FD426B05B1; Wed,  4 Nov 2026 17:32:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6186B05B2; Wed,  4 Nov 2026 17:32:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812016B05B4; Wed,  4 Nov 2026 17:32:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1E66B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:32:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBBD48086B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:32:01 +0000 (UTC)
X-FDA: 85398885642.01.D0CC8F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C6C680005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:32:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6q3gpTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831520;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pY66RTAg4gskpB0/23Dm2MncTkJlPFKDiLc2XwKGdA=;
	b=gAdx3JiYEBXXACoPPS5XYDHEBw0JvXqFjXB2Jfyjg/GCN6Z2fNeYqVFx+gsfv8ZryTZD8s
	qz4xgecsWJKajKYuTRh4+O6yytPDeztXSQpbf6LEBWHzap/a5C9J/uQiBBUlSQ3vzrSxrx
	F0ucD0gNYCnK12zSwpo9exjE5/ukrko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831520;
	b=7UNuTNsv5rET7jhOZK3AgxKCZ8mPLytXRuoNORWdT3aFaU26t97huQiQCdqbs3EHe45h4e
	aZb/Qxhpp2tKI2toplPhRAgru9hszkyjTJEbqdAJUUkqE0UGDLvXcgPYTIaVvnuWxIA3Ua
	+H9oj4a2GxWvDATumNSC/Xnj7jMCcAY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D6q3gpTp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F159460207;
	Wed,  4 Nov 2026 22:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8845A1F00A15;
	Wed,  4 Nov 2026 22:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793831518;
	bh=1pY66RTAg4gskpB0/23Dm2MncTkJlPFKDiLc2XwKGdA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D6q3gpTpKYEmJrHIaehomVhi1poKU/XVJMTpb4cma30HCgRYKwXEi0yg94psAaPV9
	 +jfeWPrBd1TSAnMyF9xk9WcIi0wKWkhiDH8FAKfcEbx0CLASo9cMQC7p5v0MKsj+Pr
	 qiLAT7mWhjo5FcN/Sdq6IfwKEPvwmn763Q8I3DukPb4Kxpexmxi6gJbEuDgYMpXTPg
	 AiBno42Cq1EmQ8F0bRjOdxLrt4o+sV5AedjjqedD/VQt9n/KwEqkLF6QDV2I6+/QXM
	 0AA88mroPgaAl7s0I53yYK/sCANQL2fpCcqCWSqvtUZjRpGZSpWlAWyg9fKJ0c0wXx
	 cHaPLHcrGWwQA==
Message-ID: <sashiko-outbox-198231@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 2/3] mm/migrate: introduce async non-temporal
 migration mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Huan Nguyen" <nhuhuan@google.com>, tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, "Chuck
 Lever" <cel@kernel.org>, "Jeff Layton" <jlayton@kernel.org>
In-Reply-To: <20261103223025.2482227-3-nhuhuan@google.com>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <20261103223025.2482227-1-nhuhuan@google.com>
 <20261103223025.2482227-3-nhuhuan@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 22:31:56 +0000
X-Stat-Signature: iqusak79rqiz7gictoprwzitdrkry56c
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C6C680005
X-HE-Tag: 1793831520-864580
X-HE-Meta: U2FsdGVkX1/vw8f5OKSBlBuvSTquwESvV2h/NOw5K50hi5ia/mIjp1RNACYB8xUYAcps3Rj3BKP6hs2NZnGzNnSA/AFUNnIFSlS/cJ7VjumjgmPYMHNiHvvOfakVqxC16oBBEk7752aQaxi9aXOCqPoEEhRUYd90EEUtO4ukKtdqnLnDlypxxKkCJMA/sWwoQGHkIBCXIwuC0P/SSd7oAED5psojWIR8E5FAmoablG+gerie0MNjNkvwtNKtBcir4+HLWTyWIqwwjzosc0t6P8n9oMoOtp4HMbXWAIKrcUO7/i/P1ByapQl7Un/62FnS3CqqGQIAq12J60pnI3gAnFbrLT4J7cu+TOwJCqy61n+cc4HdrMAK82vGIJXVTd0ZW60O3hQQAbURHqD2uI507v3uL2dQ9Ijs4q2jOyCGVVVE4F9uI/GnexW50snVhRaHQF65UMe2jLszU02GcO//L11VtZj36bO1n+NDYcD0jNEarqLja0zNDeeqEbTf3uDzemrlHpKEw3dAHs9flyftMvnof89AodSheS8LAj0w2RkqaLeBXFbfPygAgd+IrN03PS8wAcNrt/shGGweq5dRSymw2nHANUHgSWwr8SXlgs5lyEGyHCzMmtGKxlF/XIHGX3XpTTXT79N0fwAeG5+5N4WGkwEaxvvbmIpBkkAmPFSPQkvOzakNyiYyCujT+njCbaY4uc2O/kQk7ndAkZ2zFS2mEA3es9VOlU2D/vcVjg06QBwqv/wZ+R0zMqlvgIu/oIOVwxc4rvgTFK4s56HwkAEiMksW+LLpipmw64eS5tk0+CCXkRzo4bv7hq2TCNgAUZOlNkNtKL3AsCd2mZzGwnzLdeHYSxwHp6cgl9qjEdlg658w/z/2/YcaM8jh/prQKIey20htrPqeUFLbt016O+lKZvL89hZ7yGzfn3qvYZna68XOIYTk+PFuRAJbXkqDNyic9+LR3TXOZmK5t5P
 7aHBt86U
 aCpRwwzyY/t/l9oVNfinTIQBwCRyk95Fakeeu5gY+yxxK0f+FATHiMyYKg2dcBxA/ZfNYt0oPpn3defVp1eRjSxgPTRcL4PC4O83AGc+RjkWy916HuhmmFrKTaPuzMHkevHr+l88feHBjw5NxInO6O+PcixonrQboagayMzvmnw3S7qIWQQlg1EDgxFodYUO9Tg7LcGvAFass3q8691/SlJVMzuffpB1RdY270NsyjQVUPRg61mMYLn3j1C6TjvLAI9+mATiay9/dYM+poWcRnWY5yzM/bi7D7HJOGjAo5B2VlyYhaGF7xYZvNSJQfVW70S3FwnTLVYOOaNUiCTKM/ifUPRKDO1dqychhoB0N01DM0muTWicnqAoaGcjzjDLvGhxRfEGvh1wkw9nqdwG01ey5VCbq7arRpKZkaY0j5TAPamkJ8aEmC+LC/ZIAAsMn5JxqD006GWA8EpiGJ/zCBQMiRMBB4NFTxbX4mrgFLUdjW2K8MtI/L63H22OBh0kBB6l6rj87yo0Joo0HRcVl0Rc54cFLzGLJnXQg1eo+BmOgMo0N5tHOX8V527Wvgfa+KFDGEx78xAcBy0ZoyJJE9/SCrD9cP2xJu2UWyZ5j3WKL/O/XtFWAy/4Q9qWC68CLMaLZl0vGrtqEQ68mi0Gy4QLBkrhu2xqTBasN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/compaction: enum migrate_mode ordering breaks compact_zone() =
async check
--

commit 047765d971a4b565eac5e2dd50bc528791c2e77e
Author: Huan Nguyen <nhuhuan@google.com>

mm/migrate: introduce async non-temporal migration mode

This commit introduces MIGRATE_ASYNC_NONTEMPORAL to migrate cold folios
using non-temporal stores via folio_mc_copy_nt() in __migrate_folio(), and
adds migrate_is_async() to update callers across compaction, NFS, and
migration.

> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
> index 05102d4d2490e..fd752fddc972e 100644
> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -12,6 +12,7 @@ enum migrate_mode {
>  	MIGRATE_ASYNC,
>  	MIGRATE_SYNC_LIGHT,
>  	MIGRATE_SYNC,
> +	MIGRATE_ASYNC_NONTEMPORAL,
>  };

[Severity: Medium]
Does placing MIGRATE_ASYNC_NONTEMPORAL after MIGRATE_SYNC in enum
migrate_mode break the relational check in compact_zone()?

In mm/compaction.c, compact_zone() checks (cc->mode < MIGRATE_SYNC) when a
page fails to migrate within a pageblock:

mm/compaction.c:compact_zone() {
    ...
			/*
			 * If an ASYNC or SYNC_LIGHT fails to migrate a page
			 * within the pageblock_order-aligned block and
			 * fast_find_migrateblock may be used then scan the
			 * remainder of the pageblock.
			 * ...
			 */
			if (!pageblock_aligned(cc->migrate_pfn) &&
			    !cc->ignore_skip_hint && !cc->finish_pageblock &&
			    (cc->mode < MIGRATE_SYNC)) {
				cc->finish_pageblock =3D true;
    ...
				goto rescan;
			}
    ...
}

Because MIGRATE_ASYNC_NONTEMPORAL has an enum value greater than
MIGRATE_SYNC, (cc->mode < MIGRATE_SYNC) evaluates to false when compact_zon=
e()
runs with cc->mode =3D=3D MIGRATE_ASYNC_NONTEMPORAL and migration fails
mid-pageblock. That causes compact_zone() to skip setting
cc->finish_pageblock =3D true and jumping to rescan, leaving the pageblock
partially scanned without marking it skip so fast_find_migrateblock() can
repeatedly revisit it.

Should MIGRATE_ASYNC_NONTEMPORAL be placed before MIGRATE_SYNC_LIGHT in enum
migrate_mode (matching the ordering in include/trace/events/migrate.h), or
should compact_zone() check cc->mode !=3D MIGRATE_SYNC like
isolate_migratepages() does?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103223025.2482=
227-1-nhuhuan@google.com?part=3D2

