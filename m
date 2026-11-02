Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9316606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BUOGHtk2
Received: by kanga.kvack.org (Postfix)
	id C86836B05B2; Mon,  2 Nov 2026 01:53:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37256B05B6; Mon,  2 Nov 2026 01:53:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B260B6B05B7; Mon,  2 Nov 2026 01:53:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F07E6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:53:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13FF3140B90
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:53:47 +0000 (UTC)
X-FDA: 85389263694.20.511C21F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64299C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:53:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUOGHtk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793602425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i15daf++VpfZRCz0DvkW9BbXArZ1yonaTYUXl4oTyl8=;
	b=yJh1bHaKcjEFeyto7JOFFZkcYcHD5MDtnY+7jPmajWIzJbXFjz4qWV4Pb+CJ/to82LFE2M
	xJQhfN1H46/AruCgWrJ3e4DixIDE11SMOl+gf+WyhQ5Epcmg58wlnLuJTuZ00Twcupw4wI
	LAsUiv/VuzhhD0zR3gag9eCxdfMQGwU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BUOGHtk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793602425;
	b=IkbJr2C4GXO4iQwTXYkbTsCmq87XPxIk3qBwl8S+vNNN2HlCBGyP7jO84qJuPnt3wsiLvN
	AUxbaiCcd2bhjRKziFsj7FoCd6eSAftv8N8Z5EeWibxOST8psfK/YUDu02vTC19K5tzCgR
	kEHOvPK4gCq09H0fKDqMbTy8/dOXR50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D22DC60DD8;
	Mon,  2 Nov 2026 06:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3FB1F000C1;
	Mon,  2 Nov 2026 06:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793602424;
	bh=i15daf++VpfZRCz0DvkW9BbXArZ1yonaTYUXl4oTyl8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BUOGHtk2kOh7f3R1hPSmZ2ETTobY+Xi9BDxsQWKDy/S7Dr6is7pmvBxEv6SrrkwVi
	 VisOlvZrsPUOADAovsZVlV9283ZoLJ4WGG7bKIai0IJrB9ZuzpzmH33BSF2uUA6+wH
	 QAclpf/RgRyDgjLesfyKFNtGgYvqSOKNdcjAt7I6OU5oHO8fVHIdmwP86LjwS2ykwJ
	 j/d20ewplqwUYh66fKQNil+pxfb0DqdN26D2lzqDFH11Jbv+8u1iZjtfSg4nmrgj/+
	 4hmcOspD9jf79gw4Y85tysbe8CqQfgQfRX9oVPrjt5Jsta4aYKTdW5U5ZJIrmpILhy
	 KeuOlyCG8x/RQ==
Message-ID: <4211a96c-681c-4b87-8094-4f6c824ffbbf@kernel.org>
Date: Mon, 2 Nov 2026 07:53:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: Mani Tofigh <mt4022@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
 <04ad7001-bdd4-47e1-9a80-5b2464da1044@kernel.org>
 <930e2b99-df87-4aeb-88d0-d12d012edbf1@columbia.edu>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <930e2b99-df87-4aeb-88d0-d12d012edbf1@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64299C0004
X-Rspam-User: 
X-Stat-Signature: z63fzs5xw4347phkafsrq84m57dekx1o
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793602425-823866
X-HE-Meta: U2FsdGVkX19GZ3ow20LSFMuUZ4QfDPcafKojMpz+zlZ7sHLzqBjeGmP3QttURk0CpXf/wTh/nQxtbRnCF8NhNkYHUHP4RG5uQ/jQ24609tJ3vLLIkYlUMLnJgZ7hZN9bw2MPzDLN8NZnJXjziuDTeF0WvlrimylfGdhzdkPZn1KRkxg/Sp0fHq5kKxh6eIfqvvnpCSQ9hqso6nKHX+bcmepayTjn0uwhrKtRjTW1lVYupXx8XcdECvzOBId0w3yhGjIV4hvjg/w2iXTg2Ad7IhZ+VC+tB9PwQcOiwo/eEtHLTpXfiCXY2QebufRQTzzAajThprIQPfX6/IP1DGsFk8sn2u+yABuaHGUIccyVjnqZngI1xpdvDSLU0H6Hizd23+VM57TrlstcIbvkmCOzhNAih7oAUETQF1EcuCI2ZacE/UiUOPP3/TO0FW8jsHLw565irMERiaj6X3e1/SSpEGm908eAdgnV00hMxNEHMwaU8em4QOUZGATuBVcYmfJ7j4X2FgyyU3DgeN73aV50LXvnGMqadIMyT3Isync6DrmeYrfmewqigExQDPeTGp4TiWOSmMUG2jk68aluSNYDuEAeTSWHPeyUZ6cf6Cz4sfIYsyf8Y0ulU+gHRaGQ+BdAK6mYUuvXSuksHd7GwLubud69R4Cla+BVbxiqQBVl8XUn4w+/3K9e3kgUHiz0WSLOlNjOviKlrVGYS96izmTyYlMHpffZvl/oPwLC5qRCoY2alAyxGXp093ETSpeVz+cudr/jTOoC3LAiboWlsQ2T0OAFgtzu71rj+TFeXyQe/rGEb0IAh0ZXRmNTPjRDAcpIbl7CRLfeEowoerwFAX67XtWVRfuSYcCpLlx/GlZ5VqyoRwk990ttSSHZdQIOXLpJTeCUHWPcEjRojBCN9zEM2E0Kc6QpPpz2Sj68kKleANpuFQoIUwmhYtveZ1w7QrdJdC+DYmhhzUC3vJOJRot
 aUC49e23
 xgrilyQ9BZSEi+zxSp+SnC/filtklSlYHEQnl0FOKdZrkqFpWv6UaZJXBwaaGPGqM/ArcBw63wXtay79tA5MNSctt0G5KCZmwWoMD68PwTT8Z5hn6AmMTrBp2bL7+gWAAHglb0Vj04+ZeXeIVlr9CeU8S1SULkpKAzak+A3LCvyt+gEEH4udp/EsHcdQhXVZrSMISz4lDdpmBh9P64Pq7InxrMHOH4usg4puiP1f47vB6J0W0EiuQ645ebIQxy5DEUdNf4UAJJMCGTX4UIoaQNmjcOevjMyP5nQl027O0U3+zyLXG0KPLkJXx76LcJ4BOjxN0yrdjsrr96K4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 16:46, Mani Tofigh wrote:
> On 10/30/26 6:15 PM, David Hildenbrand (Arm) wrote:
>> Why is this special to large folios? I guess because a single PTE keeps the
>> large folio alive, right?
> 
> Yup. For a small folio the one PTE maps all of it so
> folio_add_new_anon_rmap() is fine there. For a larger one it marks
> every page as mapped and exclusive even though only one PTE got mapped.
> 
>> Can you pack the existing handling in do_swap_page() into a helper, pass
>> nr_pages, and reuse it here?
> Sounds good, I'll do that in v2 and send it against mm/core.git
> for-next.  One small thing in the helper you suggested though:
> the first check should be folio_test_anon() instead of
> !folio_test_anon(), otherwise a large non-anon folio would
> still get mapped.

Was just a quick hack to se what we could do with the function name. With the
VM_WARN_ON_ONCE() we might also just move the folio-swapbache dropping to the
caller, leaving the VM_WARN_ON_ONCE() check in there.

Yes, please resend against core.git, thanks!

-- 
Cheers,

David

