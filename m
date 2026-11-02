Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18CE606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dd8o8v0P
Received: by kanga.kvack.org (Postfix)
	id C75526B05B5; Mon,  2 Nov 2026 06:41:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25F86B05B6; Mon,  2 Nov 2026 06:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B154B6B05B7; Mon,  2 Nov 2026 06:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 909DC6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:41:51 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E6C7C0CB9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:41:50 +0000 (UTC)
X-FDA: 85389989580.15.AEF100F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8260820008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:41:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dd8o8v0P;
	spf=pass (imf03.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcOIUSoIkDrR2MmVp76uBcwR+fAQFhKVpcenocx2Urw=;
	b=PmcL8HWGSa9RUKlITJC4vV0HIjdcxH11GoFcbCX5iaegAiPe2kUpTz8EKQS+9yrI+5q9DT
	Lg2JhAQWiQvoQ8UGojhoEAI9sZnZJlqvcu+yJgUKnL8I8T6NY1baU2AAp3adW1jrmvKMfk
	+io8EpPnvrNAGlG+h9Hbn1dR53vP5Fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619708;
	b=P+CKC344LhQp+AuSDfp8dp8PLvxreLFuba0ehbveXE7TiNLxUdB602u7/lDn2vgBtgePHH
	yElysXkXanzQfn1xnT2D+6fUfDzjvS2tU4XGtb5OT9K2qtY4BUjci4ED4RDipy4Yx2Aklb
	/K6lmIIAhBVyfWfBDV6S0Y1pj3vT3T8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dd8o8v0P;
	spf=pass (imf03.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9682B43D79;
	Mon,  2 Nov 2026 11:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A861F00A1F;
	Mon,  2 Nov 2026 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793619707;
	bh=EcOIUSoIkDrR2MmVp76uBcwR+fAQFhKVpcenocx2Urw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Dd8o8v0PKp+YnhT1suzhHh0E1X/oM8YUd+J5zO5xPfYbaYF3AUrUKOYoLdZSE6iKz
	 xi8A0830WcyrJbkQITJoUviNIQQCM6mLXmKx/czLVE1v8g39lT+MWyn5Xp8cu522sR
	 HQnjPm660/XhxPKN0tTnUHtIjQawGZc+fGuzUtefE1HOjsniA2Jup7Ym4PcSVJej75
	 LYOHeFObr0QP85etofGe4gxgmx4IQm3QvXYoGJuc0cL1OrTjuCu/YX2QRtEfS0OYef
	 y1ul4H1HLIQFbvMDEFF2cDILRg633vgb0GQ7179TmndORP61lG+x5BKQwDfCFk/M8c
	 +SRMZus5aHZ9Q==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 172711980047;
	Mon,  2 Nov 2026 06:41:44 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 06:41:44 -0500
X-ME-Sender: <xms:9Xboam1x2t5fmiuHk1RoTGl8n8SuGSnjwJxb-vo4nUc1NsQmT8_jGw>
    <xme:9Xboaj4N9RaxPQY9G6pdWMzYPH_WsVCewc8in2HOAMdhc4e3F4aSRCKIr9-f_rFTJ
    LdGg6zlkHpA9s3UcpR1MSsOrAGNdHaTkSeOX1PNlIYPtIeNaJnW6Oml>
X-ME-Proxy-Cause: dmFkZTFf50Wbq4h86zaJrTMqckRnKO2KyVsZwVOocW/1Ty5E/45rVJCvNTCTfuTlKl1kA7
    Q2cP2VbcVryauLzt1ykhJc+tEbXNkl6yxBjN79m7rMBBW4J4XxyE+gPyhGA2jwUh1opYQ/
    rFWEGGSV7tFN0A5LeYVwhLx+Sx2PrlR8+VpJFbHFmTDRa1Sf9gcttVM456A0USxbDDf4A2
    1Yj9G+yJkfQ/S4gigj6ZG/HDTIVII3DPZNAbl534R+fCDvEQg1Ryj9huNrxF8YHsnlc6xF
    aApKjum6CjVqCyRlkSNhoL06nhdLCmw6II6or1U94pwyeNEjxQ5UCFSFWHnbc0BzP5yNqv
    lcrTjW7fFx7uJun6Nwv1yf9/ignsRr4tjp0lBBZ9VOwGUSH84QeE0+MJ33nOCBjpV10c9m
    Vpz/wNlJl4OUO1F0FDWH9ns5jtic5f3sfv/devFUcsRCkl2PcXOTCkXOMEbNcWKYQWCn2o
    XTeVymvUP57VrsypfdveqreC9kbVfnxn72jnrP6ya7/JErkLLycsA8xgav1UKVwv4fCDui
    +6LJUIaYFVqhpCXU1jzNwxCG9l+sKA6J4ois7YXV0KLhjLujJ8cC1JI0Ir781tqVYpTRTE
    aXe7adyO061dR4My6afCGSjJnvNUNttCz2UIsmrwkQwIBz+LKsOcRfITuN7w
X-ME-Proxy: <xmx:-HboaoOaeYO6QxqGwYukEsS829rqwdkuj_TinhjEE8GTqWt_I8hSJA>
    <xmx:-HboanFNW3Fxt_ab2IXF0yZANxmykM-7TTjSW2wj9jaXRTIYEa5XnA>
    <xmx:-HboauyMOHexpHnmzDcTNZ0Wjj14i9Q0igz-O4nWl7Be6tlorep4HQ>
    <xmx:-HboagqHqnWBKElaLgDtNLNNrttOHW1ydOfNElACoLkg_CBV_poUMA>
    <xmx:-HboasmcFvWt_H2qoV6Yd_wSGzhbJd9puFPmiXidxb6sq2OMgZoxC_d2>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 92F85F8008E; Mon,  2 Nov 2026 06:41:41 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 12:41:21 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Pankaj Gupta" <pankaj.gupta@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
 "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-kernel@vger.kernel.org,
 "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org
Message-Id: <bd56cfa0-6fdc-4e83-b571-f2abf647afa2@app.fastmail.com>
In-Reply-To: <20261102113127.161823-1-pankaj.gupta@amd.com>
References: <20261102113127.161823-1-pankaj.gupta@amd.com>
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no longer
 E820 RAM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8260820008
X-Stat-Signature: n6qdcfzgaoi1q5tfaft5ffc4yffyozfr
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793619708-270751
X-HE-Meta: U2FsdGVkX1/py5gEyaFkVYP6gjSFMri/EWKmVx6WdvJXE/1jSYtIrUP+2PicY31W7PhOWA1LmoNYJ+bq4qjcf7RuIUL27pDjs3Ti/kjpLgEoZ0/2fSyQYVvcxSX99ru+65he4dr4hwaFgwLq49aoG5eOH63uP8UPl5+ch6C9lG2/QKHB3f9OxEwFy5NmgBzueSWYrYX8Mhg972rZnQMb5kcj4j5lT8NsJ90uMYhSTSRrOyXx9s0W3SFVyB+F3i10jKiJUVDu+E26jx8sCRoiVUL6VJGkUIZCUfFM3IvD4/cJM//MqhNpW76rcemvg4zXrZ5s3aDpa2Pyo1UtvuurVOFA2UMpXZZDSvPF9qwXtg18yvnJc85LCcSMrbBgwF0Fv8rRX9Y4NxG3I80jliI8DmpiYE2sBd9AfX+TEn3yVUYX8tuGqP9oASe8fpoMyejdHvFZwS08UNuTfAKslQ9Jh4koJuqdsIgb+W6aDL0YGhf+TIvhXpUdEETZ+5i5lWHqemalINvkuTMswSD0DEXwE/QntTZgRDMz4e8NpS2pgn45RjnFW0V/4FKoSdDl3vCtaRvCKDde7nRs/fLAYueyuiIAatXOSL8PZ6iNh0o+47PZ6eke+ojN8ek7N8GVEIYLE/iUb3kPfo3F0kDCkU7Qy5H1vKPVEzSVQYhJqlXW08JVrtngx/VapiSdIzBCVBNI3bD6TqD83lx79APKuHpstcTCaQoDkOFCgeKUw/FsdPvCIq9rKjaGWMnH3pPP1U7bjoB0WsrY1Y+Kz+kl/wKVWhafk5K9wFPa3kPaj25jkA/Hs4e1Gq4crnGorGoKdNuS+EksSV9rQWWqwEpq7Gy7fN4Nhi0qwk3DssfucX5AMqmsH0ut8y9RcGnzKQa8vhnwyeSZPQruM3a8EnzYFiCUwSElyN9XQW2RzBBECAvh0PGspTBq7XfqvBSwQ4TgIpgABTm+kSrp6tGXsfQ2RZO
 UksWF6m/
 0EQotA5lQ0Yre0HEvsXO39vowOgj2XoFGF9GBZAu9S9cFnvKQT+eWy57HJTlMShXXRETY/XSNIqwCjZGE+TCsejWflcomBEVjdmg9sv6+t0ADYXNosc1nUgIdSYwJrRuaWJd/HYjy0eSqtnYxYwpQvSiFIS+quflPyTK5Qwd1rxDn8iOlyVwieqlGEpyExJM5tiIGj2MxUosXC2YGpdmpwxZKAsrJsw4Gjnj8BT/IqSTkb74mfFzYD8QjR+6jZF6IgKNedrRfCMDCbVt+TJR2QMcd/EdqXtoVXTjEFsBi0htjDKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Pankaj,

On Mon, 2 Nov 2026, at 12:31, Pankaj Gupta wrote:
> The EFI stub builds the unaccepted memory bitmap before the kernel parses
> its command line.  Option memmap=<size>$<addr> removes RAM from the E820
> map while its bits are still set in the bitmap.
>
> The removed range, such as a memmap=...$... hole, is then still treated as
> unaccepted RAM and accept_memory() tries to accept it.  The hole is not
> mapped, so on SEV-SNP the PVALIDATE faults and the guest crashes early in
> the boot:
>
>   BUG: unable to handle page fault for address: ffff8a14bfe00000
>   RIP: 0010:pvalidate_pages+0xc0/0x250
>    set_pages_state+0x41a/0x440
>    snp_accept_memory+0x3e/0x50
>    accept_memory+0x186/0x260
>    __free_pages_core+0xd2/0x240
>    memblock_free_pages+0x1b/0x30
>    memblock_free_all+0x275/0x2d0
>
> This was seen with memmap=2M$0x1ffe00000, a 2 MiB hole in RAM, on a 19 GiB
> SNP guest with lazy acceptance.
>
> Fixes: 2053bc57f367 ("efi: Add unaccepted memory support")
> Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---
>  arch/x86/include/asm/unaccepted_memory.h | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>

Can we just disallow memmap= when running in a confidential VM?


