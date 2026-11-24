Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF80606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dqqlTEQh
Received: by kanga.kvack.org (Postfix)
	id 6ECBD6B0665; Tue, 24 Nov 2026 04:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DC96B0667; Tue, 24 Nov 2026 04:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2B86B0668; Tue, 24 Nov 2026 04:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2109E6B0665
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:54:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86A5CA01E5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:54:11 +0000 (UTC)
X-FDA: 85469551902.09.664FCD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C12E240006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:54:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqqlTEQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795514049;
	b=NX4AQ0Qvcup58LnqPNb3AFlwnDaFe7GL7jDopcFN+3kiEBpM/kKhYixjIozOd5zyyiTA1T
	Nt96LiLMwrnh8d4HL4NO0wWUwzZXnR5mOJ9V5MhkwBRkEhHw11LcPxM7iI0keeowReTSY2
	usTX2t0wKwaZPYhrKesiNLSzln7VKW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795514049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45P2RZGr/NNLYBc6XWk0C9YyD+ZiYFFlT4rbeHN0ego=;
	b=hNcRwpsgFS5305QsXGJYdL/V2NvDjesZl4Tg4hZEodwlDoHla8PMbZUz5wqe93YAMN/Zl3
	9n7B6oCVjbw3r7LBYx878abx9Ct+IEuw/lfAHgMlxWfMIRT0iL9UipKTHfqbefAsxgj6cB
	OP/uK5zVkp7Vu3yq6YVTOo9/G0BIBQI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dqqlTEQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 54F7461D57;
	Tue, 24 Nov 2026 09:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626B61F000D0;
	Tue, 24 Nov 2026 09:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795514048;
	bh=45P2RZGr/NNLYBc6XWk0C9YyD+ZiYFFlT4rbeHN0ego=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dqqlTEQhjdS39JHAK9oA/ErZz7HSUQ7ANm1iBXa7V3UMUk+2KbXMLWGopvlBceV8Y
	 BbvJnkfsoXcnURF+8uwKbOxPTg+YiIviIBsOhdWkY+BW47QuN9g6Qkintlfi56/kgc
	 DIoUnjlzj7h/Iuyy3BZjovX9jL48oBHE2mdtCiK+F6vHlgm/owZPgWhu6UvDo6brFp
	 gT98Lu/+qoYFdEznNQyZ1PnDTqhNe6pDZT4+CeNY1aNdfV+GVrHK3BcANgMKVnqFBe
	 Wu2l6yjnrsbIwDnIeCYgBjmbI7/uSQjUYaYzAC1rTF1Tubw+Kref+8rvc1LdbsF4yA
	 RRWVpfV/b5iZg==
Message-ID: <f2dc7958-638d-45f8-845b-a35b50355988@kernel.org>
Date: Tue, 24 Nov 2026 10:54:04 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
 <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
 <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C12E240006
X-Stat-Signature: a5dcwboinz99ef6dn87haarffayqxgf1
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795514049-712209
X-HE-Meta: U2FsdGVkX1/UQQJh6BxEWvjJtesz69mYAKqnd4s9/6JR58/pqX0htKBoDsYlpQR11t1KDSQrAxhpqvuYidCBcZ0LUf5ezeTdxr4xArYl/t8roWQ6SnBYxt0J3ObZYYQ7yFGNOdVB++7ov2jY2XC2aGSJz6ue0XGjI0hcsTcrNNPeBZhBKU91nFUy3oxd7wshlbQ1t2WllINNdIs2ykZJ5/jglvuZ2VBna8YZNZD1yhr8Cp+b7IYLhhG95spIgLMQ7vQ6p9c8QfxeINqdh7K22f8S/+5Mv8LQGeo3/AdD6ysRXGnmHDBgNB19i74Ok2rDmOOl94prMhtvEBT4HTW2mungoy1DolxUQNkzLWWXj3w9qYdw+D3RUshVHWqNlmDG/mWs2DyxyT5P4GQRFINOefau5oy0DM/vFLVDuDQezJJZWX44MradD2TOJTaY/EWpejY8Mja0IXSIjDCJ0qLSlb6T4Nfl1T9aWH41j/WswfxHz7U9+EYZRmKkYN5OSJ69MNDUEn8Sj+zBGKM0drPxFDChJwiL5UCvscsOiBxbANdOhBBMzj+a15Fq3o1d410ca12xgsr1RR4rfosomVYYTjJt/3CV6xkAGRbWQb+Zo35WSC68w1mleTntXkQC9xSfXGYBgIKh93isPUwEJEpwYUdKzBCI2v2DgcYSq1UKCBI1HipkcHvA4q/lDf0G82jHze5O4a5ubRzC8mYVW0Ewfukotj/UqX8lxIYUmYmQg2qBHVl7pMVVBZF8bKMuATZM/BzHuVw1FqWy/TjklDGcdyLjwggx9/wQFZJYEDCxDtzD97tFoNcANFpH1LWpvYtsVxK9NdH/VULtlVaZwSx7hqQVNNP62WPJC6u47VEcaBJt2+PZEwqlYcoXD+xGo3V3/0cHfpDjF5zQVTTsoV5QoM2JrgYtDSFCwzvDNG/almo0zFTI+hsJzlEbwq2zulaUVldXqhy7caZPxKGGVs0
 Bn+1/n50
 9vITFvpD6g4W7ksnSIZ+aF4Ipk21jEYntrIBqiN+0XvAq0k2W0jWM5rwJLhHI6xYQiu1P4nNdsiapj+0aQYb0Tc2N2FpxndaeVHYjM2Kr3d9I6eTkI5scluh7L8OhxLP13N4MaoNm88t/k5XVi91d2m4sCcjdqNIAixSCdREPJEHp94pI4kr/0RQAYPfleo85CeNQTPtS1AFaUBb9MidnBelruVifRxupNNEXXoWOrLRWldFMG8JaTRNGG6e9tdFBylCTHel9QFrh7HGkPXT9ehmJ8So5tikib2MWnwKfCeEO6m1MBCvwe1NZHd8B21ts13qeJpTZoy0lyLAavoDzqqn1s3CEOMmqr6IP1LuFUH5XwparF9GpLcPRt6yu5PQq8S5dpj90zOEVEcvM/WBZwpPGCT1Fma671DrjZMujme8tvzw3UkgtURFxsSBN7kSVItoqd6E1d4W1b2sdpLFVxhK90EFcu42ROjQBMIhpp9yX8wQV+gT/Nqz/D3mTFzVL1UMxhhX3eXAFKwmevpLfzaosi3FRBW1fZAuW56161GD8qq/SI9Bv13b5aZjOZMufvHUM6DQyG47F4WGJixw4G8bBLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 10:49, Vlastimil Babka (SUSE) wrote:
> On 11/24/26 09:22, David Hildenbrand (Arm) wrote:
>> On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
>>>
>>> Seems it is, thanks a lot!
>>>
>>>
>>> Yes "just to the original" is what I meant.
>>>
>>>
>>> Yeah. After all, the same is true for lore.kernel.org :)
>>
>> I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.
> 
> Hmm wonder if there's a way to make b4 filter those out, or we ask
> Konstantin to add that way.

One has to use --single-message, but that won't work on multi-patch series.
Maybe "-P 1-3" etc will work.

-- 
Cheers,

David

