Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121C8E68169
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA6D6B0005; Tue, 17 Feb 2026 05:38:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA9C6B0089; Tue, 17 Feb 2026 05:38:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDFB6B008A; Tue, 17 Feb 2026 05:38:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1F76B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:38:38 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA8155E282
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:38:37 +0000 (UTC)
X-FDA: 84453599874.25.EF97827
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4E6D9A0009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:38:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etlqVu25;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771324716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnf+wPLbEF1lHCNDnDZBiFjIcPRcx+LUUY9aUKEUsG8=;
	b=yiU65H7hIH28szlsvGpA/XefLtQAMExwE74eBOLtSGdif51+YpEpNaib28ESkqoYa4stNx
	wfxHzPANlvuye7jkqZC1oGJmSAesbpLbFdcLYyHbiVokEb3rZ8GStWY/iEryQTEqmDo/5a
	Kd0thjf+1Kbn1RnWLf106IJB2Z2mlIU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=etlqVu25;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771324716; a=rsa-sha256;
	cv=none;
	b=vIdpaWbvtzRyGQWUcdbR8icDBbZQ2C0Lk8Nu39V4Vjsqrw9gbI06QR1cnxH6uPkbfFxpa5
	lV4hX7zvJpFW0y00glrTn+2R+jeRWAut/ndHLvpNd2Esz0dutQ2kf0gmkwzs4D7TQvKFc0
	+pV+dTRwGgjXYtE1uub3dxANZZSo10w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 602B043874;
	Tue, 17 Feb 2026 10:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F4C4CEF7;
	Tue, 17 Feb 2026 10:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771324715;
	bh=b2lTnIYAJLe4yjFgG5uGsPClpzLp2piqy3H57BEyaeg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=etlqVu25p6py4s3tgHqvehmXJbfHWLUXTQWu0l9id4rxKG/XT4IgBB9XOKGaR1a54
	 +tisrA7K1cEDtHb2Ed8tS2hq0v8BWH+13+povr+tFlJk11W4GcP9DLIZlS6eKDz1in
	 8Erai/K06fq2WP1QyEX/gvPbC8F4EMkpz7IUzEdkOTTEnE6tbjPeU6jN54kY0h3gh/
	 269C8HU/qj1EhQxyhu0aii4c9vMjmsiBwX1aRaaz47KVSqyXDoX/na7vzHNMJQ2T7E
	 sEGttv7qmqoNfflsNpxZMkGZF5+O7nVfl81Q1opdCBKGTrK5lHKXCnklWKytGDKH4e
	 +1WPBbVupE0oQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2] liveupdate: luo_file: remember retrieve() status
In-Reply-To: <20260216134408.12dc6f88f7139054f9e34637@linux-foundation.org>
	(Andrew Morton's message of "Mon, 16 Feb 2026 13:44:08 -0800")
References: <20260216132221.987987-1-pratyush@kernel.org>
	<20260216134408.12dc6f88f7139054f9e34637@linux-foundation.org>
Date: Tue, 17 Feb 2026 11:38:32 +0100
Message-ID: <2vxz342zzmc7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: oormc4ku16oc5di4b8a9ppqpfkuow7t1
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E6D9A0009
X-HE-Tag: 1771324716-663029
X-HE-Meta: U2FsdGVkX1+7TUqctWCA4OeM7an/KVwpw5f+W25UUS2p3CQFEYDLsnVxr4vZ9IiUnqgzf2J2u77Z8MPpIa7Z8FPi628xfdnVymi9EfRRRyOeXxRLewjZvEqv+CPFPRtgXY1k9kCqE005k1+akSqWGJ9OzWA9i5wQZzMw1rIrntolj/67iz2RYE6Hqez4bMdb2iFRIilCVocEQX/NZ8y7aVFLEMO/Uh+AUbzbfQ5F1jsbPEIHYCaqWGRFvPNCurBipdykhffaeAp0OMLUbDRwreM/XSc/OZB7V5yWDIDgFnrqUreNhZof2wzKKKQ5DSKisihKAr1S/OPBz7saOsg3CWsCkWV9w6izP7ehtk5jQ2uROCINivNXdZ2RxvrWxQP2Wv3n/WfVpBzz+LNvwMDTWuI3rGqj6M+/VxHhOKPfU13Y3ik1moyp6DAEYapx8GETWojTTC1QIWJbFo2bpjJouozDikoRRy0LpD2JVcj1SVA9uxUNOa5jTNMRIkQm80DZRbzB5FyXdXkNluq2L6yFGE3NzD/ehrD/OZHJ5WHe0xFnKDSkzEndMmB4U2XHQMTpPlC19FNJhS4j0xYTEGeOI/DcC/7UB4H4X+JvlxSpPZk+NIYpbCnEEBl4h2f/MYdKDOvuEDkpsuGjMvTZLTWb2QrXVZgwqPsV0lillGo7/TyeqqmGqqBdeyHcjrnxRwYi7OZLzmKXl2Kybti5X1q/lALVthA23NRHX0Gmv3jZCblFinlQd+bHl2A4TaNFytJKZx4jZY8M/HhORgfsCMnWRJRMEmDSFbVtftctfHYrF6kF6Mqhw9hsYYA8dGSmAMnHcB0vuVYxThLUpRdZTpscZZ2clnSjaEGX4wFNkO5aH13i2VhrkSgMLN+K0UtHQHPxzvwPjV9FbDOG3oxINiT6AiK98aPdPWgjaBA8wBjoUMZ92pj81zeKlsemUL+QBGml
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16 2026, Andrew Morton wrote:

> On Mon, 16 Feb 2026 14:22:19 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:
>
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> LUO keeps track of successful retrieve attempts on a LUO file. It does
>> so to avoid multiple retrievals of the same file. Multiple retrievals
>> cause problems because once the file is retrieved, the serialized data
>> structures are likely freed and the file is likely in a very different
>> state from what the code expects.
>> 
>> The retrieve boolean in struct luo_file keeps track of this, and is
>> passed to the finish callback so it knows what work was already done and
>> what it has left to do.
>> 
>> All this works well when retrieve succeeds. When it fails,
>> luo_retrieve_file() returns the error immediately, without ever storing
>> anywhere that a retrieve was attempted or what its error code was. This
>> results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
>> but nothing prevents it from trying this again.
>> 
>> The retry is problematic for much of the same reasons listed above. The
>> file is likely in a very different state than what the retrieve logic
>> normally expects, and it might even have freed some serialization data
>> structures. Attempting to access them or free them again is going to
>> break things.
>> 
>> For example, if memfd managed to restore 8 of its 10 folios, but fails
>> on the 9th, a subsequent retrieve attempt will try to call
>> kho_restore_folio() on the first folio again, and that will fail with a
>> warning since it is an invalid operation.
>> 
>> Apart from the retry, finish() also breaks. Since on failure the
>> retrieved bool in luo_file is never touched, the finish() call on
>> session close will tell the file handler that retrieve was never
>> attempted, and it will try to access or free the data structures that
>> might not exist, much in the same way as the retry attempt.
>> 
>> There is no sane way of attempting the retrieve again. Remember the
>> error retrieve returned and directly return it on a retry. Also pass
>> this status code to finish() so it can make the right decision on the
>> work it needs to do.
>> 
>> This is done by changing the bool to an integer. A value of 0 means
>> retrieve was never attempted, a positive value means it succeeded, and a
>> negative value means it failed and the error code is the value.
>> 
>> Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
>
> Should we backport this into 6.19.1?

Yes.

I keep forgetting that a Fixes tag alone isn't enough for stable
backports and I should add Cc: stable@vger.kernel.org too.

Please add it to the patch.

-- 
Regards,
Pratyush Yadav

