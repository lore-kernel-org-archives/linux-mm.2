Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CDBC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704FB6B0095; Fri, 28 Aug 2026 09:46:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6AA6B0096; Fri, 28 Aug 2026 09:46:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A5226B0098; Fri, 28 Aug 2026 09:46:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA586B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:46:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3946803A4
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:08 +0000 (UTC)
X-FDA: 85150802016.23.0ECE646
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC10CC000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:46:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjUjFPGg;
	spf=pass (imf10.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924766;
	b=NpjVLFT58A3ZndCohB/0uVYeDrN4Ijdj9ICvbGsQz/uz+K6IaakXIUiwkjJdeXvZSfEQeT
	KrRsUVAZGFobMl7vk2Zoah8Ui62Ww25uWVgpT87oRPz/Ga7foPOXBMlMFBfL/r7zL1JxVS
	vTMmwEcKLNpXO31++uMOA+/06XadnfU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NjUjFPGg;
	spf=pass (imf10.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkAIK4sJSZ+M6U7rXtAMjWYbvL4XnlFujZHGVX//GSY=;
	b=XI99+Bioh54FHOsJPQIm8AxrxfAlveuJn96o7xwmF2IZ0r/QMF+Sf14emRWlY8DOCzfSSR
	2H8ROpXa9EHRGIol/AE3uCVvuuDY+oRZnX8N8LCw7mhIQwABhY0X3ZqLMgUg2Gs+uuHYQb
	FRyAaDIYYO1icEm2mY/D/etxjcVO80k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA4F341455;
	Fri, 28 Aug 2026 13:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61C81F000E9;
	Fri, 28 Aug 2026 13:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787924765;
	bh=ZkAIK4sJSZ+M6U7rXtAMjWYbvL4XnlFujZHGVX//GSY=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=NjUjFPGg1szvr3eb78v2BpGQv+wgHid47nEyNFCF4UtD4VOdqNOt8xN/TmW/lz7pC
	 Hfb3M4OLv9NBqnBI+kJP2HzzaQSfvx4FzS4UkOu2qMkys/Jzo+q0CYKmZHRdS8Cfoj
	 JqFpNq+Z2uR2W0ItcWD+dCY9h2kI2Pmtons2mtYREqzuyo7tePoAoomC+yQ+/8dMxh
	 MYP2TMHM1ohEBtisAJojUoUmBbyoKBQAGOZ2Dgt2MclbRwi7ECg1HEnTtD0fhWK0ol
	 OchJFRcQw7oZASNd4EtzB9ztlpmIdHTFtHoNS9+K5QGBPzOzEazxuoD3I83FcQ3XIJ
	 x6jZWn3Eo7bEQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 5F2B21980072;
	Fri, 28 Aug 2026 09:46:03 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 28 Aug 2026 09:46:03 -0400
X-ME-Sender: <xms:F5GRaqE2NkgyW7Ns-LsvSLTTDYKdh01qS6ZTDLQ4fw9t-N0Ddrtc0Q>
    <xme:F5GRamK8JEod1kC8v70PUAKg83EM3BJ4mNsF9zenJckTWXg_DbGiqaZsOaLiTcf1f
    Un5nzICP58n5e2w4IxsrJ6DR2ew4HXCRnU0kgMGarbUP730m9edsSHf>
X-ME-Proxy-Cause: dmFkZTERWf76UbFSBm7gP10dcMTeqKkA8/cAL0sZG2rtqNj9Cm8XygX+z/UkBm5JSSVYUy
    tiYsLDls4/Z8P0ArKeB4JwxyT1aUPV/lD2jc7QsFKIVQHQani//0H1PZEuJk/TiRbXXB2d
    2quRJqkXk73Cy9UXGvcExqZtTKUBQHobcpzJhpw2JFide00btCWCAKJxj+FFD/0LYuztV0
    RDQfQ9I5GuMU2Gp/6HPTrAQR0FUWuP5nz+ODfL0oI1jx4s+jzNT/OxnaNHzIWAbOUDVPAP
    w5fd1Gn9Re9N8rvjRkwEA2WKBs4KNvy7cNDKTIaIdI60cHjToYvMPt6lZJQt9iOoIsFcNt
    RgMeFGqQHwKXp/37eumLweC5yrLclcKzJJT5cNY+IHV1VdIyqIG3ZtBU5HWRsmj47nFXXO
    E35L8lICEmkjQ8uKpI/zFxfHP7ZNKUlS9+8zbra8ZkiUUpsAFf0YCS46pUJJrUCDgx6aMI
    V3tmtGKfMb0aauZJvHtfGU1pRrhYIJs+OLLCQ73AXWjoo3DemVX15rIZX+nlbfZxakHWuF
    qQOXvsSwhEkofy7Mi18iqc/ZOGzI2iapsjruAeX/BsRit5HFPQYWWAYVRwICynS23+3qDa
    lSE1BUqfAQ+/hmaZUT/n/B29/elggaG5nEArlIRIROmCs2ooVKdFgmt50K7A
X-ME-Proxy: <xmx:G5GRaidmDIofxjDrnckkltqpU-EBp3Rle_aBNo2F6P7BC62Z4iDwZQ>
    <xmx:G5GRagLQLLdIZbdkb7L2guevnkadNbHtrAwSNHFCWgxQJ7GeNQ4xXQ>
    <xmx:G5GRasCciwc4APHUJloqDeNMxyVffl53TzupnMualIviek0VAjp3Uw>
    <xmx:G5GRaphOIhi5fNP21BBwmTKuIl5vQHIh-O74BW-RnFIO-oBnHepfnQ>
    <xmx:G5GRamNZICx_vr-e_gFs2Augf5avMnxddCHXulCSvH7Iw1aF3MgajzWL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 89751F80080; Fri, 28 Aug 2026 09:45:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Fri, 28 Aug 2026 15:45:39 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Petr Pavlu" <petr.pavlu@suse.com>, "Ard Biesheuvel" <ardb+git@google.com>
Cc: "Catalin Marinas" <catalin.marinas@arm.com>,
 "Will Deacon" <will@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Luis Chamberlain" <mcgrof@kernel.org>,
 "Daniel Gomez" <da.gomez@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "Aaron Tomlin" <atomlin@atomlin.com>,
 =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Kevin Brodsky" <kevin.brodsky@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org
Message-Id: <cee89666-9de0-4012-b665-69da3846c5ef@app.fastmail.com>
In-Reply-To: <524b5817-c097-47cb-b301-4a9c0f1d2947@suse.com>
References: <20260822135323.795946-11-ardb+git@google.com>
 <524b5817-c097-47cb-b301-4a9c0f1d2947@suse.com>
Subject: Re: [RFC PATCH 0/9] arm64: Allocate .text and .init.text together
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC10CC000A
X-Stat-Signature: 6gonyjohg6nkbn7xye4nq5i5dy1sirbc
X-Rspam-User: 
X-HE-Tag: 1787924766-99706
X-HE-Meta: U2FsdGVkX1/bYgLWR5kAr2BgohVGV58JYA/qBjCk/UTpQjdDDJaQ0mMymj8kd0yyuWFFsnf7JC2s5OhLCFoYHmOVeLPbni9aFFdubFEHlcahPO+txWa5nAwKssJIJKE0iYO60I1lHAcMsE0gZdRmTYo5MLep4CYa4qkeHYMl9BghC8/mBkb/sby6rdhWNNXif1DnSg9jgekJrz6yxfp/R8kIki2I7ntdyIbHVZgagbDmMLImGjHCx+fN3ERPrThWDbkDjVmVvUcacuGspcwqrGQoM7aI28UYRRC8MT+13oCoZEleV3AaJ0eyxCCfdAye96PohhaWAF8G7IAxllzRIhPBfIL68wJk5hz8YwkVfTPHUWc4jW6EAD9tY1aqrMm4DmAd+iuR+t4BmydBA8IlWndYu8v5iDpF2ALG1NQTzg908Mg6oosUHnnnBg2sAmaEtqvS8ryA9zdorRFQQvxk5W5gmIRKuupkT2TrHjgts838n+QIv47s0m8m76MiQNcmQdmvLMEc/9xyoRj5FSWsNKfFGSPtBheo3Q75dqXa4RnDMS3EVh62qOd3sFh0HHptpmBAz7/cGqFSdo3fzcxmI2D1VAeO7NgSnRwm4phRolHW3u13KVSUnoaa3E403o897XHCzv0x9G71sCdoHKjuyvFVx8LdnIqpPYXlSJFa84/CUcl8Q2itM+EtAZyFI2P4vnOEzPr7/8N1jn4uG9xocBLCwq//K2nMYh9LV8Fmb7mNWHIL0VQeUb4efbqSNfluam3t+24WlzKvfgdDsCkS11nctAJgOpbGbBYyXMCjnLPF1aZui6FAoagTvlqKXBinURO14GbiF7U9NmWMf1pWk/6ZajzCtYxmraWZGRRcqWTmw8Lmi3CHQtmbE3LE4KmGe1eUJiT96zpow/LP5ESKGRv+y2GXw4XPfY1bHw/HU7mrGOXfmG8PPxdlvrtZmNVK5XqV54k2NqdRLYQpUkP
 DrAdNNwz
 yA8jCksYv9Mz2uH+B1+++k0goGdFp9DjHJY17iG0vSgYcV9ZTTkOMieVwoxV7M5Y3ezMpED5IiCypVkjdQwwgY9nSyjsKSlTGovoityec9ictZ2BXzd5aXJ5eZ27hjrO5XiFjopZbBcxgSM7RmQT/o7GQO23b/3ZE+ZWqdx3qtsCq4jMJpjDYWleurS8DMdiiFNeVqDil1hHIgJU2WlLVpF/OSFRr0obI6Wk0SxsJ1ZAD2oY8bCeB/djnb2GyAf/4XSvM/Y/0m7URvePohTQalmKwwuhlPLdaxkZ0fk+EQmcdKbG3mRcynyaVBAr4vwhm8wui0n6iaT9FDJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 28 Aug 2026, at 15:07, Petr Pavlu wrote:
> On 8/22/26 3:53 PM, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> The arm64 module loader has to deal with a couple of corner cases that
>> may occur when .init.text is placed out of direct branch range of .text:
>> 
>> - ordinary direct branches from .init.text into .text may require the
>>   use of a PLT entry (i.e., a trampoline aka veneer), which means not
>>   only that additional PLT entries need to be allocated for
>>   cross-section calls, but also that .init.text needs its own PLT
>>   reservation, as the one in .text will be out of range as well;
>> 
>> - dynamic patching of the ftrace handler into .init.text code needs its
>>   own dedicated trampoline as the one in .text may be too far away.
>> 
>> - recent compilers may omit BTI veneers for static functions that never
>>   have their address taken, and so additional veneers will need to be
>>   added to .text in case cross-section direct branches from .init.text 
>>   require a PLT entry (and therefore a landing pad at the target end).
>> 
>> This is unfortunate, because it is actually somewhat unusual for .text
>> and .init.text to be so far away from each other: only when allocating
>> either of them (but not both) exhausts the 'near' (PLT-less) module
>> region, the other will be allocated from the spillover region, which is
>> not in direct branching range, and therefore requires PLT entries for
>> cross-section calls.
>> 
>> This series addresses this wart by allocating both of them as a single
>> chunk, and freeing the .init.text part along with the other init
>> sections at the appropriate time. This ensures that the two regions will
>> never require veneers for cross-section calls, allowing the arm64 module
>> loader to be simplified.
>
> It looks like this should also be useful for ppc64, which currently
> merges .init.text and .text because keeping them separate would require
> stubs between the two, and consequently .init.text is never released in
> modules on this architecture.
>

Thanks for the data point - are those stubs needed when there is some
distance between the placements of .text and .init.text?


