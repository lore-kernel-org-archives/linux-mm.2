Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A00ED3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31556B0005; Mon,  8 Dec 2025 06:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08AF6B0007; Mon,  8 Dec 2025 06:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9459E6B0008; Mon,  8 Dec 2025 06:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 802636B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:36:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B65C95C2B4
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:36:49 +0000 (UTC)
X-FDA: 84196101738.04.834A397
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E7444000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:36:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBTQcGYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765193807; a=rsa-sha256;
	cv=none;
	b=nYX7gKXnTAo8+MLmtNyq01lg2uVox1NTPPSYLEFKZQur/dm+W2f+wOzOjd3ZsK9mOsvipg
	ULkTXhKjrZBp+royg8WPZJtm0C4+F/FQlPqPZjdpXphrYgHvpHWfMgr9DdnEbR02iFw4Cx
	qQ8irrmXylS5Fx0JKxHiBC1g8acYljc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBTQcGYW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765193807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EehPWAEXsADMxfatqI4snoq178r4WZjB0fmd3wXqy/Q=;
	b=GfPvzF8Ok57G9eH1d44niWDUAd4KMBQ8yibYFVBSCUOGwxMLrNrTbSMsMDGuwV3c3QyPYA
	mDBD7Wzi6xFiE8lvmu/ee3FAxSXqbB6Y9G5x7DSMp837EBhtmShsYuNcXhz7C9u3l0NL26
	0JK9+G0FmRA1dHoexY4SOQbV8pc+gn0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 563CC6013C;
	Mon,  8 Dec 2025 11:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF129C4CEF1;
	Mon,  8 Dec 2025 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765193806;
	bh=YNWal0I/AH1LFdEiVmw8rnxCMpBAtc16rJQWMT3Zsk4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SBTQcGYWwGF9rF2zFHEDI6g91h/lU/t6xv/fGssMyKgesFbdb3KEjo7838vl+6w5G
	 Xi4HCMSErMIo7K0aeUdZBDZ3UxAnc+W7x5FJzRCro5HZZETB454E/hcqn6ug648KI3
	 mKf6fmjwZqKTCEhdA/C6jnI+9Dx4oe1cbpCTbx12iDeZu0++7HhcpuRfROlBPAfnv2
	 45dbykMlhmAFwtH2ThLZOIBPnN7dqIztWGzSeo51l5eukd1joYMtuJEZAw+IGaRAyC
	 r/SMmASxmcQtiFvq93gv23WMpVGzKKwf9CQ3TMrUoqrAF0vgH67BdSm6bTceiV7vxr
	 QwAl2pVezgJxg==
Message-ID: <ecac9bc7-d048-44cb-ae49-f380cd180e55@kernel.org>
Date: Mon, 8 Dec 2025 12:36:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
To: Shardul Bankar <shardul.b@mpiricsoftware.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 dev.jain@arm.com, janak@mpiricsoftware.com, shardulsb08@gmail.com
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
 <d651e943-99f5-431e-a67d-e4e6784e720e@kernel.org>
 <edc1773d7d2e36682f607549a1f69b1bc503f72e.camel@mpiricsoftware.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <edc1773d7d2e36682f607549a1f69b1bc503f72e.camel@mpiricsoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E7444000A
X-Stat-Signature: zw146k9nsx5mnk7jwyn6dhuuwhi5c9dn
X-Rspam-User: 
X-HE-Tag: 1765193806-453688
X-HE-Meta: U2FsdGVkX1/1LxgmuRYPBhDDACPQCpYFmRYnKPxjK8q1uNYsfQNdwR5/gyFF8v4QYmGMbp8azOVAsn7PSBD4IfDE0WWo8wmcoplz63Q/T72ZHZ21k2y6zf3TbMuCiUNnm1nX6fiHsYJ/719Y4l8lJU6Sn5nYsvzvpKmlIwLlISmhtdVPlln/cV/++9Pt5sIFON8sk9jbHQGZV8id/H5Za24IDYJ88qSDk/Eou4QVztTvuIfKIMojcU81pPTkuZhNBhC6pV2phCa3YZ7mfGFPPfekgMJu9jLB7kV8BPawpv4XgXkmasc47mpvmMTgWeZnvlZ9hGYjJOnytCjRMsMGguPRqW5XiNEqobPYLUNA/rQDZRV2z9kVZbDZufFpPfhGUcsJvIjk673zJG/qc579sS0ZN1ThxRpXCJ1XTVELyMhc2v7IhB4FDJZ/1ZyUj+n4Kk7cln8zBPv1WXD2tBiVISB+2trqPBSHa7bE0vhYl2tyqy2eOHHtOmm3lO3YyN0Rx2fJLWyw5W5Zp49UX6mK1YYj4M+yeJX0sLS/cATxQ8DhyXYJmWzhhWAq46a8xYwBjBryGTh0VUqnBMOtGA2c4gc4ClMw9/waUXvty7rXBXnEVjtmFc1vOiVQLjZHnAqrT+aJg11oF92VqHnwdwGjCg+B6BbOmO6snv0k4gbjEs1qgUCk16YnJ0DSdcJYl4WLYgKIYdjF9Csw6e+gqO3whYfcF123J+NvcInOW7Di5hs5d0fEZPUSJQXOeNeS+CmHzv0SWShQTPYJ/NsYGdc+TfYC9aib3S7Z+7bDCUZxwkeQKjPO7WhlbEZ5O9ceUoWOvBj35yFza8TwybWMr8HA0lRVgwxOKtvjVePYwy/4VssV2E8eLZDSRnGUA2ZF5Ngw41HWTgbUyXmOs5rCnqzivGg3qs7FxNOefBNPd9Esp/2Bsljpv/DfjudjF5kcbnjbk7sig+TadphWYZ64SoW
 lm9RLba/
 Pw97ugh+JERWJG71o3WEOENKQqlubnorGvf/S4ldS77oMGzH46ASaTVQvhjhAo+MnuUt80oDr3uWox9ccMA4ZCpSQnN/dGDfU5bG4o7SjPIRCgysGGyUYoQrf90VZJXRPLtwXJ6EMHzEdaW3eeGHWDJhss+2PBlbREt0juywO55bUwaj2R3ftJMDi5YNfxbTQlEOSfLO86AkA2xSgIYhQYDsj4H3v0PhNy2CZkfDiptERIlpOnDEcYwDDlXBegAu0F45H9VdWrKZCclSh0rs84ez7ejiSl5L/VUnKWEpS+0tBQ4ASJcbM+xMCUCuxd04/k8asSEIv2zhxpfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> -restore:
>> -       xas->xa_shift = shift;
>> -       xas->xa_sibs = sibs;
>> -       xas->xa_index = index;
>> -       return;
>> -success:
>> -       xas->xa_index = index;
>> -       if (xas->xa_node)
>> -               xas_set_offset(xas);
>> +       if (success) {
>> +               xas->xa_index = index;
>> +               if (xas->xa_node)
>> +                       xas_set_offset(xas);
>> +       } else {
>> +               xas->xa_shift = shift;
>> +               xas->xa_sibs = sibs;
>> +               xas->xa_index = index;
>> +       }
>> +       /* Free any unused spare node from xas_nomem() */
>> +       xas_destroy(xas);
>>    }
>>    EXPORT_SYMBOL_GPL(xas_create_range);
>>
>>
> Your bool-based version reads nicer; I’m happy to follow up with a
> small cleanup patch on top that switches xas_create_range() over to
> that style (with a Suggested-by tag).

Yeah, feel free to send a cleanup out that removes some of these labels
(doesn't necessarily have to be what I proposed).

-- 
Cheers

David

