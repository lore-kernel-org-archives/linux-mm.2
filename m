Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B97ECA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 15:11:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F698E0007; Mon, 22 Sep 2025 11:11:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8058E0001; Mon, 22 Sep 2025 11:11:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF348E0007; Mon, 22 Sep 2025 11:11:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 829F28E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 11:11:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AA05160143
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:11:17 +0000 (UTC)
X-FDA: 83917224594.24.5EEF42C
Received: from sonic302-27.consmr.mail.ne1.yahoo.com (sonic302-27.consmr.mail.ne1.yahoo.com [66.163.186.153])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2D7B740007
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 15:11:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=J9DwI9EE
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758553875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4InEgJCpBgl3urehuyUAnpN3vmaPh6mhZWLVpIhzL0s=;
	b=slVOkpJWLjA7McetCwXSuupoi5oOK45F2i/x89IgT5FRLBQSASijo/MQxwNe5pYwoH2DJ2
	kzeNBP0OJGF5I4usmpdLcmBPNIagswB+ewcfG0J4gYsc/xJOiwSBMhe95j1/rYpBjJpsNO
	oJ6sMWCqkZPwIWX98HspODnU8aezc4M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758553875; a=rsa-sha256;
	cv=none;
	b=DvHfB/rKbDMO6KRiNMkJ+nnR5yDi56qV1Uy25q6iPwBVIWZnNtpKeqs/pbYh97qoESvrPd
	Uw4SVSBzWpXd8/XsL2egDvSmNHrMSjNXoA7xO9UgWwEN80Rk1Kyof3Q690D5IsdAOr/iIf
	9zsbtbqN3MAS/JQ/G6BmfQGbW54FuhQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=yahoo.com header.s=s2048 header.b=J9DwI9EE;
	spf=none (imf01.hostedemail.com: domain of casey@schaufler-ca.com has no SPF policy when checking 66.163.186.153) smtp.mailfrom=casey@schaufler-ca.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1758553874; bh=4InEgJCpBgl3urehuyUAnpN3vmaPh6mhZWLVpIhzL0s=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=J9DwI9EEoSSW/Lkrr72eSxtrXRRENkjzKi46wW+Sysdd5SAjSVeIV4hgsLSA+JggqGnnt2M9wh7N0MfEiHO2gJR8amsnXUNwHU1/2ki/mr2IbJS4SpuLz1N4Ypj6XtaVdAeHXL/Lbikc+EMiYIhoLSVZuSWehpzhAhFZmcItDq2W3vUCwT+dafBVcOmnYNF/F9ZELG3HfEXIRpHiUwbwDCG6DBBbP6QhGUeVn79618epXSbHiu8hzGhRZGMDKocstCp6uOTE6S62y8udiG8HI5Jrkm0BxRWAChR1b+rKbQp5pV2+BMMabI9y2BAi0RsHcuI4RhQi+MNRhgXIiQFgRQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1758553874; bh=KPwtAbCxygioSedyi/zH4YiPp0McrAJ3B+cmGMWen8n=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=cNlIa+GgmUR4wuvMfIB8WqyYSEX08UMsLE+92KlNC2P/yka3ghVo6hU6YPEvjWL7fZFQUrO417uXOMvZwUAAH5hPqAIf9OzZM7Y39W9y2lcROyU0QToz5a5oJ5P1XGaPPcS58kY7N9vBtO6BQy9pNgIajYzJzO+hDYaUQWmfIhbgs7fRs7yv3gccc/svi7WlbGkbhDWwXa5d/jiY7dZH4E9mjchUAMbc6RCC63G/iiv6KwRqdM87luBlAFkvsVRS7vcQNq6Mq6sV5lCRyhW96NiPuZHLcdSbcVzkpQ+92kvkzDPWEFKS09KgIrOIib74OlO030E1+1YptjS8yNSj/Q==
X-YMail-OSG: a0ShGM0VM1kS5TdAKyhzMZn1kR2BVScsxCyqUC96KXfqWNmQ7dmcDUkr2C6CD8o
 F.nNwGtrFxyWKgcaKU7c7SzY5sLRNB.kOmj5_1Qm6ugm1qKEKbdGmcF7HD5CS6uaMhzE.a9se2Qm
 F1aP8aIzBCHkxN5RNu9eVRSUSnetYV4eQU1XVm4hTaEV4BvxehZwefxFMd6x0JG.j4dEDQi93AD1
 otuyzSX1.GPHdlyHguPAligClB4vPQXogx4pmPFUNZvIgnYUj3ZAP.eaGvtLAJBWwJZIid7F8Yl7
 fS1HoQ7Jn3KoiQxx99h22rBrZa75BNGmyO0gktHMEZP6MXXhe53TSWat_vR8FAYXp_VD4R4oJuz0
 DW.oPlaIk1ghcJ.KbdLt0LsHV4.48F61tmZEA3FvDg6dnsPKuRGJnMhywRU4K6.kIxo9YPvXQjHB
 F0IEgZLPfOcJ8vj_r5t6ph71MsJq.FE_dJwSDuVWC2OfTIwu3UL950I4YXO0txdngQH3weqQJq6v
 Gd0etDBRenLr.nP4ZVooL08C.kalSnyjilbjQ6hVCbAJFQ5ac5tNMA0yqzDKczYaots_sFff8rvv
 U5vBtTDHFGj9pG1htEk98Bie3Sr1Rh3DfjslgmdEQKnh1_RrMAZSOAa.07QtYLdpDe2ASHqoxstq
 qYaXJgEdH5PCYA35nG5kb60ezbJkPPwOgISysqsYtBczyL7aM0o_YWb87zjEpMrncOBftQRPUxzI
 yY2X1SAcAlN74EUshXhNxN7bDz0fJ9pyw6Z2FsRjy8NP0ZZgh77q88u5.20P4ilTVK7xnx3zwYf4
 Uzh2YFJ6lpxu_av3Ty_RSjjqPs_hrHqzS4E2lP1u8zR0J5nKWFZkiuKSJTrN8DJgClAmJqKAahC0
 NDUnpko2yADSzuuEpuBlBsqp8tv6uhW8teFJt.gLBrwD3pm5T1jSk.0wbeWpfWdlekkEEZwV3NPS
 xZ7VgGeoZC1jxaMek4SWmhHxcE34bMEKU.ZgnVDtv1vB2BQqLi_s6d77dWDiquPUaQAUCXKkMaQP
 uhDhqmwm8pzBqj2r0bYaLSBcqFrAk51e5s4ikqTrwey9HRuUMMB8Eh2Y1HQR9LL_GE.p6iKBKxnX
 nIXVe7cgbeMhuuSyEyhK5k_DGnSaPAqBjwhWbkQQ0EBc3l6dBpb4.Oz6IoO_8WCoLqoiiNyfdai.
 bJqa6nOKQrPDM66mVqWCrlXJ6g1wtUV7f9_RR3ivDzll782rXlyXthQ7MUGtc1O4ztwW9feR0AFR
 uC4vfcZi7p42Pwj2PiMqaKleTA3XAs8ovvKSBT_szRVp_5si5CjN8VyeemuMZTkLEg.rLNOiNPCG
 ytsLPAaDfYvVFrPfcdyYVnIQ2F2svsSmcLS6d07AwqKDkUlZFTirlX5SPJb30aKtLsfZA2vXA1dX
 byb6p2XV5WARbEoql4FkflHp67betBxxYfMoBuk5wsBX.R08duRAeIA7ywEmn2K_jb6_P91vCYMA
 AbckozoJFCLrgV6CWtns8rSzy395xhacTQzNQERJ8u6dQJMrmDYQtaS9J7y33Fwf1vHuWoK09FpM
 l8kJwIWULCnK5tjBv7iWW6LyslPyakaCL6mla8FXtIRDOQbAeGbSfW1aSxgcC89DZHcc2bM0x8e5
 sBoSsKO.AGS65jFjJYffvA9clbSmTISPOj4t64jG0sZpeeCe8VIxXz7WWTqU0XxkmCWiYwIn6KV_
 aUtD_EmSIWjW.J3jq2SVufM16hzqmUzhgU1aFQiACBwp.U2rG._edaOcsQrGJYKlS8tWmS4PL22D
 jSQIOAzuGq548u_mkww0AMgNAVQvlG67kcZ6SNXiFjW.k5iAUl1TlfCPEdCqsi8GWQRdneOBomfT
 ueajbwUt99M2nKlAjWvxQ_hy0RWGK3Ij4TWwNUYFNIsCXb0AsEOgYljPYO3dSJ0UbJwD6wzpABrG
 yZP5OsJLBK6ojQjJFmlGDMCbP7c5vxhge0mlgEPh6ACFt6Pqodho68OWazPnWVRIDSME785Zll_g
 CCQ9BuMOs.kMWTm4pGh28YO3BgmPcOl4hV.JK8XCiEgQY.4EQko2_W9u3bFfLa.Rdf_KvchZbSnR
 YcjkZQL3Gjhl21R0v_mm0v7UmSWebJxuIgVF4JOQehB9F_WNlcDfoawNwAtelzKXFXTaFRp_C6wK
 eszOxCUPqTPOQ_dI8MUlSoTR6Ga9y3m4NFIPKfqe_INBR5CwIx2F23bdEgas1vlI64GNmzsihuP2
 lxI_3RbdGVHuDr69RVlRtRbANidYaUSGf53wBBeZlpqudBL7u_btetqsP2Keq_y6GEDrgR_icQFg
 BgrZFVqwNWg479To-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 2c354591-3949-4080-84f2-5cc1785b2062
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.ne1.yahoo.com with HTTP; Mon, 22 Sep 2025 15:11:14 +0000
Received: by hermes--production-gq1-6f9f7cb74b-2n2jr (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 5a83043d0b8f6a0e34f3bfd1c61ea603;
          Mon, 22 Sep 2025 15:11:07 +0000 (UTC)
Message-ID: <8403fd9a-6667-4202-bd5b-5e83172961b3@schaufler-ca.com>
Date: Mon, 22 Sep 2025 08:11:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/39] convert smackfs
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
 raven@themaw.net, miklos@szeredi.hu, a.hindborg@kernel.org,
 linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
 linux-usb@vger.kernel.org, paul@paul-moore.com,
 linuxppc-dev@lists.ozlabs.org, borntraeger@linux.ibm.com,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
 <20250920074759.3564072-10-viro@zeniv.linux.org.uk>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250920074759.3564072-10-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.24425 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Stat-Signature: q9fp3idnbnk4f91yrop1idy6wwh1nio6
X-Rspamd-Queue-Id: 2D7B740007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758553875-723259
X-HE-Meta: U2FsdGVkX1++ENjFur5sBECT5aFoNiAndJpSBXNKawFVAmrt3jG3+NvSDVUk4L1d11DW5Bvz4HUk2xzgp9CbclVgHAf3mdk662Ef6m06CorZE/0o3LMAjqb4T3MgpdwW/jU1iZXQTE6IxGWInJiK/qE5sURglNFEyz9LG5GHePjF9Ncl547qWq3DvPKo2sSKdTn9xextEI+d2bmK12dGjgBhvV2hPwjzzJJuP/qy+rU9oMUfmeduHyFAKxp4Mc0d557U13UTG5/qgI70E7nfV9lO/PVuaiuhnqqKmfDicw+DNbG90RIqAuURqI2hW1EW0f1xpMBIEJ6PxTBX7g+bYZZb38x4NplQgLZ6U/zzXJssylnuybUsoJnatzkWBtbjH/5Oq41ktbPuQI4A7fCXgnQGN2Z7FSFr/xX9rLFgzYy+T65ZHuQ6vnloL73V8NBxDMDf075Q3C+r4QnKJA/e/gqXxvss9wxbDp/i2XW4p+ivNRtFqYQkrB+n0UxwRiFSweMmfhPjc7E2Ro0TnF37m6Pr5wrHUoUPrZ4EdXrqzaPqajM81h7mSAAgEpoaLh5SdZf+LdZ0DiTXybrVFKjO05POWKotFHbcQBJhZA2EwHTfZR8UsX3cCV7rs8/9P3pYP7Mb8mIGe3al5ppPo/reZjyOkhKZ8qjXtuC9jbhe5f1tlauU7CoOTFVVSd6yMMN4clG2IwD82AL4Oc8ymVeuR92jFwsh8wNuwNq0IoxOrj+P/kxHpgu4BlWtvMV+LzENLm8HEbtONCuxeAmZusndlhjztT9BtaPgQ87q1qOv7w7x8BBoK9S34hCR3FXoy3CBQmhQ/sf5M+IzVVcURoxbPzfZMzV2EWpQe9Kq4r6xpXsyyqb5wMXnxtn38I3uKJ8+4bgtCJY4nx6sDiwliX7H4J0CUJaTXhgyM82AwTmNz9rsSoFIqa2nFAzmGkQNbSccAuzAxHg3+dN+4XfVt//
 fRf6EU+I
 cZjKldHBL2YRtUMckf5xuhQZrzLY+e6Aej0PzrS/yA1yBesVKPx2kZ7+wjwH23Ka+MUzKaI9ZySw5BWU66mTYW5aAy0mB/sRdHNuI9JlaxJ/OhUVs9jws66Ck5inxgDXl2xIQQVfEfZvxug/6e6ulA1KD8q22nkuyip8tfuCD8w195l7SY7rXR4q9Q2xqdEF8XEEWQvI4hVqrYzShYBmrSpf7fYr8UQCgXOl/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000051, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/2025 12:47 AM, Al Viro wrote:
> Entirely static tree populated by simple_fill_super().  Can use
> kill_anon_super() as-is.
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Looks fine to me.
Acked-by: Casey Schaufler <casey@schaufler-ca.com>

> ---
>  security/smack/smackfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index b1e5e62f5cbd..e989ae3890c7 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -2960,7 +2960,7 @@ static int smk_init_fs_context(struct fs_context *fc)
>  static struct file_system_type smk_fs_type = {
>  	.name		= "smackfs",
>  	.init_fs_context = smk_init_fs_context,
> -	.kill_sb	= kill_litter_super,
> +	.kill_sb	= kill_anon_super,
>  };
>  
>  static struct vfsmount *smackfs_mount;

