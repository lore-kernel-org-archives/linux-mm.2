Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417E1E66886
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21FE6B0088; Fri, 19 Dec 2025 22:26:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5416B0089; Fri, 19 Dec 2025 22:26:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7886B008A; Fri, 19 Dec 2025 22:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1006B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:26:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27058140420
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:26:18 +0000 (UTC)
X-FDA: 84238411236.18.556F419
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 56FA64000A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:26:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phms4Nd6;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766201176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4+Amfyrox8uas0sWao73yoqMJGIxvV4pb6+PRCdA3s=;
	b=wMAPbx/viWhivJe4JufTafJ8VtwRHDf4Zo+8cEfT3x4rAnlduIR8T/UorBI5tlANCXUXbZ
	VFjYamkk0NY5fYGNXueNt75sexqIvjqkwNxTVE3UoaLACbqbP+NIWRDvxFVZlbEoVJkbkj
	dOZmO2D3xsh3cONnAJsrR1LDYQ1dNRQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=phms4Nd6;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766201176; a=rsa-sha256;
	cv=none;
	b=B/TJOzDlQNIQT9wLZnWXHp6o+AEfeHwINwSBSPCjGa4+NCpa1t5uO9Cpn5C/4+xzzdYZ3H
	QwMilPo1sPP7HXJdva6hHVJf4RRYw6HtUto97hgNX0C5Ealz40WYwvcu+rM+2b9/SlAYIi
	JceteTGPgg17wo4IwKEhThFFdItvoY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55C084437A;
	Sat, 20 Dec 2025 03:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15A2C4CEF5;
	Sat, 20 Dec 2025 03:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766201175;
	bh=EnAo8tjl0LeLPwSTVsKJgQguKuTTfJq16l9GOU0BmgI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=phms4Nd6aQSaSqIIrs7tdFGtUthysBdYR/4KUwsLEko27qXKr9jeITU/Y660l86gX
	 dnDJBEWToNz9fEG6IGkuV7uKzIcIKzTF5pnuo52ubwmGMfSHDV4Ab5LQetAx4dhYLU
	 DQCPur2SWniNGSj6O0YbWfGGYPomemOaisSZyoDKGQhG5uF6ymmvwXdf4cdLCrYrFe
	 gUtTS33mU/WNSQKk+AeI/8T1+lFeukh+B5DmNx6bFr1a6ihStU+lxVih2azmbAVTie
	 hS9hWVFX2ObIMZWnGz4wektpS41jHSJ8W+XdOE2HhKwLgZcUrfbZI7EeUm7LkphO5S
	 Y5ZiABDTgnitQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam
 R. Howlett" <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Jonathan Corbet <corbet@lwn.net>,  Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>,  Borislav Petkov <bp@alien8.de>,  Dave
 Hansen <dave.hansen@linux.intel.com>,  x86@kernel.org,  "H. Peter Anvin"
 <hpa@zytor.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar Salvador
 <osalvador@suse.de>,  Alexander Graf <graf@amazon.com>,  David Matlack
 <dmatlack@google.com>,  David Rientjes <rientjes@google.com>,  Jason
 Gunthorpe <jgg@nvidia.com>,  Samiullah Khawaja <skhawaja@google.com>,
  Vipin Sharma <vipinsh@google.com>,  Zhu Yanjun <yanjun.zhu@linux.dev>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  linux-doc@vger.kernel.org,  kexec@lists.infradead.org
Subject: Re: [RFC PATCH 04/10] liveupdate: flb: allow getting FLB data in
 early boot
In-Reply-To: <CA+CK2bAV1y_LySjyj-wcn1cdSuVBdC+r+zQL7AQTY64nk3OxuQ@mail.gmail.com>
	(Pasha Tatashin's message of "Thu, 18 Dec 2025 13:25:32 -0500")
References: <20251206230222.853493-1-pratyush@kernel.org>
	<20251206230222.853493-5-pratyush@kernel.org>
	<CA+CK2bAV1y_LySjyj-wcn1cdSuVBdC+r+zQL7AQTY64nk3OxuQ@mail.gmail.com>
Date: Sat, 20 Dec 2025 12:26:05 +0900
Message-ID: <86wm2hj0ky.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ga56i33iqtrjhyfmsbesr8z9yr36r6dk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56FA64000A
X-HE-Tag: 1766201176-849032
X-HE-Meta: U2FsdGVkX18A5FkzOjJ/S3b+h5480QB8az/Xaf6fJOjL29woBvPztg/8b9GjBiDsoB1erNul3PZY4OpsmqLaMtbo0klrzE73LKglp9psrTnTZgMuO+mski7nwG+HP/4xSvasRvtgpqF7nVHQ20FBkLoc2VOya71sUV3RtQ1htm/O+/QTl0ukIa7CA/L9WoZnZRn0FOmbFYYXJS2/ogGPJwOFeC8fiGi6eHwwPkAjaerDXE9mrPbc8cI459IsAGG68FVGlGBjBLOHU2mw4A+naREQCUScf3Lpnr5L2arypyqqzunkMA3Sqx+thb4UHTsAh2YL5XyerLCP6Y9FAqziK75aL0IYLHpoy47c75Gd6tfyBisrYBAkya3gkF2qxlJ+Np0dFJxMzCEs9K6KVHphi5UF1IakmWmc2Ca9Mc9GmtvDVM4Z8/lZGay05BSgsqe/Sn6zxuhLN9hWtQ3/3V7XwcTPorLHmSrRrFcdgbx8W+/8StEy9UcIm3jWBGehduW43yfJ9gIzGcDalYOqyb5X5RTCRcfR6H0VsRQbq2G3ujZnMKHL5e4ZaFHw9iRcTGxDd9+WoWdEwv5Anqg3QnXsnHsNWBDVxNr+vLMBiKb1LV4XoWjkGOUfHyKvBlN/+9Bs5iRnN+mRLbWUxDYOsrHtgYD5XDBw4ZUlwQTSuqL9vMi0EzLCtkXQ0hVIX+yB9bq/+OnfjEvZikvE5+rp7DMldogS2fze1qXukXISdzBIBtqQ5u4TZzdicuy3LmP+xluZEwOg68DGGFQZ9zeB82kDoq+sXVp1MPxCsns9WmOLcxoqPXKmC+m+ysNpjAeS3I2CpZBllllsltX6xnzn29xPDq6Drrb7s++8g3rGNgAecrPvxJSyH+K0jb+z7MKqHi1R3LbnkVdoSd6vOlrMndNIsPtBfauV4m9+Ng3b/2UxVLjyOSwBE5sOaZt4RbLcmCqpJWCAaFjTlQBKjauIxAi
 Bv9U61/w
 utF58fSaf6XBWfrdq/fUwr8I7tavqiVzSdzuskTAPcjQ+dbHhQANBqPmoMZ9xUigDIJnlWtsDoSN0+NkALAjiW7L6HzdhHbq8XtzhRbxG5gAQBXX2indZjWItA7DSRr4I56jDlXTNWptYvYAfnOP0U7f/3KqhKu4cxDa3fgMbKPhmHzXGannEAvwW9pf82Ag7OeF9G2IPcgj8MsY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18 2025, Pasha Tatashin wrote:

> On Sat, Dec 6, 2025 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>>
>> To support hugepage preservation using LUO, the hugetlb subsystem needs
>> to get liveupdate data when it allocates the hugepages to find out how
>> many pages are coming from live update. This data is preserved via LUO
>> FLB.
>>
>> Since gigantic hugepage allocations happen before LUO (and much of the
>> rest of the system) is initialized, the usual
>> liveupdate_flb_get_incoming() can not work.
>>
>> Add a read-only variant that fetches the FLB data but does not trigger
>> its retrieve or do any locking or reference counting. It is the caller's
>> responsibility to make sure there are no side effects of using this data
>> to the proper retrieve call that would happen later.
>>
>> Refactor the logic to find the right FLB in the serialized data in a
>> helper that can be used from both luo_flb_retrieve_one() (called from
>> luo_flb_get_incoming()), and from luo_flb_get_incoming_early().
>>
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> ---
>>  include/linux/liveupdate.h  |  6 ++++
>>  kernel/liveupdate/luo_flb.c | 69 +++++++++++++++++++++++++++++--------
>>  2 files changed, 60 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
>> index 78e8c529e4e7..39b429d2c62c 100644
>> --- a/include/linux/liveupdate.h
>> +++ b/include/linux/liveupdate.h
>> @@ -232,6 +232,7 @@ int liveupdate_unregister_flb(struct liveupdate_file=
_handler *fh,
>>
>>  int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp=
);
>>  int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp=
);
>> +int liveupdate_flb_incoming_early(struct liveupdate_flb *flb, u64 *data=
p);
>
> Hi Pratyush,
>
> [Follow-up from LPC discussion]
>
> This patch is not needed, you can use liveupdate_flb_get_incoming()
> directly in early boot. The main concern is that we take mutex in that
> function, but that I think is safe. The might_sleep() has the proper
> handling to be called early in boot, it has "system_state =3D=3D
> SYSTEM_BOOTING" check to silence warning during boot.

Right. I will give it a try. For hugetlb, this works fine since it
doesn't really need to do much in FLB retrieve anyway, it just needs to
parse some data structures.

If other subsystems end up needing a two-part retrieve, one in early
boot and one later, then I think it would be a good idea to model that
properly instead of leaving it up to the subsystem to manage it.

Anyway, that isn't a real problem today so let's look at it when it does
show up.

--=20
Regards,
Pratyush Yadav

