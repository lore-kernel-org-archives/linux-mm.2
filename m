Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB5BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E9E6B0005; Wed, 29 Apr 2026 00:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127126B008A; Wed, 29 Apr 2026 00:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0641D6B0096; Wed, 29 Apr 2026 00:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E84FF6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:21:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3DB48C65E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:19:07 +0000 (UTC)
X-FDA: 84710288334.20.F457ABE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B8A420005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:19:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WP7MpNsD;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777436346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgdkPDsgSgyFBEabURf3W75QiN4fDtGI45IFE9lTYH4=;
	b=CJVEFsgm5N+6iGgiIVLjv8YB1RTq/npx3ylWPNaO5KkavSCuOoeEk+tprHC0GSRp1MgrDw
	ga86lysF3y540GPSNM1ruQJ4for3TL0QzHQk1tdav88hI9hY7N5a+NJHolfjl/L/YZeyLR
	OUuy580IWlXziF5Mz0T0kw45gXxTwZk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WP7MpNsD;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777436346; a=rsa-sha256;
	cv=none;
	b=0FV577wH24LDhliBHxz7WlSV2+mPuV8g3Mx7cm3j79Hx1Rr1uUfGW2/oepPKZSE9pkkiB1
	/F7IO0z1YGUpU1YQ1HeTttjocctrwUjxHgcGOu7LSslHiJTkBMQYce/ytsxXSNZQ/Vgk8v
	NT5pgVRqvNE/TpogeFf8k5gYoT+DM9M=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777436343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OgdkPDsgSgyFBEabURf3W75QiN4fDtGI45IFE9lTYH4=;
	b=WP7MpNsDlyw+uUIvXwQLhMDusj9kfWjZhgawN6yMi1hHqW0eD31IZPqp3Cwh+IbLopMsho
	2yl/q6fB1znPpkEvLkzL3zkFgSMcooH0E3cFH3R/OrL77HAcmH8dUMWNPRTehx5bIagm+S
	jSIsJEnan3SMjR2iEK4BVFruFG1ya/g=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH v2 3/3] drivers/base/memory: fix locking for poison
 accounting lookup
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afF7vI_fNXs4mCVA@localhost.localdomain>
Date: Wed, 29 Apr 2026 12:18:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Ying Huang <huang.ying.caritas@gmail.com>,
 Dan Williams <djbw@kernel.org>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 David Hildenbrand <david@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Rafael J Wysocki <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A3EF6D95-E3B9-4228-9AED-A7018ED494C5@linux.dev>
References: <94F5B89A-008A-4EDB-920F-31B4895C2699@linux.dev>
 <c6e1df1e-be5e-2468-d46e-453985ba1e79@huawei.com>
 <afF7vI_fNXs4mCVA@localhost.localdomain>
To: Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8B8A420005
X-Stat-Signature: ydtn1hmcfhab7igg7quotc7am531uk5t
X-HE-Tag: 1777436345-213013
X-HE-Meta: U2FsdGVkX18QRJY/9NtoCxjDR7ps8g6XdHvXSJJme4xDuUuqvRaEbjwTMfR0PPkSlG6ei/9j1z7Z4iJiZiJTTybtPKt78MLxXD2VcpdAsSmlmiQ74my745176ltP78qyKpy2V9FMEs+Ad+BvS4mMCGBFHnZewt76mqRGx9bJO/JpTwKNwdyfFAbWG7HCAuAIkxnQeEd2MPz7cfcc944xFQGOA3en9w1pJuAxGJNHIulTqRMKs0rLFa5cE9tNxESe89kCEKMRvg7jdZcqgn3+tICWRDIu35Dj0GZD0fZKBY185Oo2s0yNBUVeVhQ6McixzOwXyzdZxZ+P2oF73u/fm36Fnd2yjaNK/+CWNE1kn6cqY5UhEApFcSRjAooBwHMT+JNxQXXFrInBdINFuMOY9Bib8OxyoQZaJs5Qq9BX+zWatpSKP9UD7bRKg99OvkjD5P26Seo8JQOcUStG9X2ZGA5xZVlLNYBUFoMdTvvCFbJ5mtjEmTDw3jp00rJWigY714KgKhikGJNZ0fqJagwi351rxHLRA0ltvzL7FR2v61x5W+ksw5Zr2pG6iImEFdZxYEmqpP72mOEj8E/dkZlZfrjTOYHhUA5F/yPwmscekLVzu0OXzuOit85HRRiIoew4btRFbPnNycVhnoogxva+qvhqNOXOmupQ+V1qPHuvF1vQncXcnpGydbXZbHwJX6pFlgGy+373MuimC+/6FJWBYHR1AZbx1yQq3JBxrESzJkTqNp6x9iA9D+NM57pjGAoaZxYjkkvTcFTnCVuvP/XR8qiHafAFYa9gbQcuwOoCYodLKc+HvyQKw5XrRmGjBYejr2WJFCXfK9pC2ABRtqhECDh8eA3J/fnHh4XjLW9QA+0D6hY8NH2Kh/13MEo7i+1piT3JoXfYpCBDLi73JK1xqaiFloaYQOGFsUZjqxiTeun8r0CH3HPCDu4fpfC82MWtwuXXTXHh5qqCUKvmkme
 9hWJbZa8
 Ra1qfJenPrTmA1eCH08q+BDd/LIulISROxm3Dv+QzfHprX8bzHssO7ZKEXY+KFzPoszvhrJ2/LzswPr3GVM97tAo20WyL8TrJADdxE6VIEIuNd6g9Hm6/O8r721M/xT7okrKZR0kAQXCO18ITuQpZHxO3Q2nxn+kBTbxSP6Qqn3l3VmB5HTEdDajs7sRDyNh3LlbyA/fhctfzVj1Luai4rNgXoHxlScHC/+LCmTWfSSkhIVqRvy8H8Y7RLQfAqMAXBPcRsyVwpzYptDSLo8pGMBmTWzkgbDgC0XGk8u+HATO5k99jQF3PR1jy/L/tzy/kTML/U6P5PAw9DX9n3ZTAS19VBxWKXEqtDS+d7MnpIJHeJcCOlSTwc5C/Q8fmvfHx2orclzX3Rx8r5oo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 29, 2026, at 11:32, Oscar Salvador <osalvador@suse.de> wrote:
>=20
> On Wed, Apr 29, 2026 at 11:08:51AM +0800, Miaohe Lin wrote:
>> Right, I missed that. Thanks. But I'm still worried that there might =
be potential issues.
>> For example, this function could be called while lock_page is held. =
Acquiring lock_device_hotplug
>> while already holding lock_page might cause problems, though I =
haven't seen any specific issues yet.
>> Also there might be some other potential scenarios that haven't been =
considered. Hope I'm just
>> overthinking it. :)
>=20
> lock_device_hotplug is a mutex lock, and we already take other mutex =
locks while
> holding lock_folio in other paths, so I am not sure I see what should =
be special
> in this case.

Hi Oscar and Miaohe,

I saw sashiko's report [1] related to folio lock and =
lock_device_hotplug.
Seems it is possible. You can correct me if I am wrong.

[1] =
https://sashiko.dev/#/patchset/20260428085219.1316047-1-songmuchun%40byted=
ance.com

We could fix this by calling action_result() without holding folio lock.
What do you think?

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..bc76066547ce 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2534,8 +2534,9 @@ int memory_failure(unsigned long pfn, int flags)
         * Abort on fail: __filemap_remove_folio() assumes unmapped =
page.
         */
        if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
+               folio_unlock(folio);
                res =3D action_result(pfn, MF_MSG_UNMAP_FAILED, =
MF_FAILED);
-               goto unlock_page;
+               goto unlock_mutex;
        }

        /*
@@ -2543,16 +2544,15 @@ int memory_failure(unsigned long pfn, int flags)
         */
        if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
            folio->mapping =3D=3D NULL) {
+               folio_unlock(folio);
                res =3D action_result(pfn, MF_MSG_TRUNCATED_LRU, =
MF_IGNORED);
-               goto unlock_page;
+               goto unlock_mutex;
        }

 identify_page_state:
        res =3D identify_page_state(pfn, p, page_flags);
        mutex_unlock(&mf_mutex);
        return res;
-unlock_page:
-       folio_unlock(folio);
 unlock_mutex:
        mutex_unlock(&mf_mutex);
        return res;

>=20
>=20
> --=20
> Oscar Salvador
> SUSE Labs


