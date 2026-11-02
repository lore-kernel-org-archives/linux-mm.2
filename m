Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F87D606A330
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dIMU5P/5
Received: by kanga.kvack.org (Postfix)
	id 6460C6B05B4; Mon,  2 Nov 2026 07:53:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C396B05B5; Mon,  2 Nov 2026 07:53:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535986B05B6; Mon,  2 Nov 2026 07:53:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0576B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:53:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E3F40D10
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:53:18 +0000 (UTC)
X-FDA: 85390169676.04.30DA1B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D6FC280009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:53:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dIMU5P/5";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793623996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijfgBYo2lcQ0Tr0sYHboCjedjNEhiovIXXVXgY6yBGY=;
	b=Tpcb4coubI8th3pYbARU7sKnNV3k4rJIzWP5MrovcN8GbmAXvAA5uJh7tNJW70iQ8JesY1
	albb42OtfescUPZf0yUYIDtw1l/nUZiCMgVrha0ZWeYyiS89kgaY5hnyqpaamftx+V4lnL
	tDP9+ccFoY2ZiQpfhkjz68xybLtdX40=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dIMU5P/5";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793623997;
	b=SSUPnbGPDlmaeDPp11G9v7A2+wxCzZWICQ25I9Ky9seGGwlbt6lEymStxrqaAIeY7OXeLr
	h3trLlG+fLGBXn2vRqZfmFIeENEHEU/0FJ5ZKOajB07gKWZW6uA/7JSeVP9UYzM42hOLeW
	uJA7+iN35VwESK5spuR0lWz0LrtsbBY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1490C43A57;
	Mon,  2 Nov 2026 12:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6E31F00A17;
	Mon,  2 Nov 2026 12:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793623996;
	bh=ijfgBYo2lcQ0Tr0sYHboCjedjNEhiovIXXVXgY6yBGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dIMU5P/5NKuiVlBu3RpjjqCXHsVSQVCF+PtSwono2pYLRWyrCGQCF210arQQDztes
	 miih4rmoGkEDiOxAY1uFRV9MKzjHlDQ4vDxdqvfhIrgJ4MkGPqxZ3ErvMKbU8TdacD
	 tczs9FDE/Io7XoWAEL6mwB1qOd27Cg3feRae5Vv35k+kK/reyms3+TM5DrOw0bJm2a
	 OQoHfA/zrYNOGc8hNT+r/vp9ZD+h9kqt3WhMy/h02yiW5qjDgX2XLrWUkh+Qw2ub8u
	 Jc8x9Wmx6mSZoJa3baPdNkOsRbQMLmorNO/BWLbs//HLrjh7x5hK3MMU6dVrfk2K8y
	 bYcveRhiIN9XQ==
Message-ID: <8412a82a-f5bc-474d-b810-11a97a25c231@kernel.org>
Date: Mon, 2 Nov 2026 13:53:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] tools/mm/thpmaps: fix missing mapping names
To: Weilin Tong <tongweilin@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
 <20261027074904.3328878-4-tongweilin@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027074904.3328878-4-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D6FC280009
X-Stat-Signature: e7c11ikze43ipjg77uounyymnhsd9uxe
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793623996-689679
X-HE-Meta: U2FsdGVkX1/be0Nc9KWX4vGONwW3mJldiGfumSAZvHHfOTxSOFx3s06govUCXt2yOcga+j72liDEXkg4S9tf9LdAb2+sqsajgKJCF5Y4f3DqVsWw8dvys6+0j0y9Bf8BH+3JkV3a/Qq/RBuOwjLHarHGlnNDGSDcAh8CL4WCLlEtzbG7YYW6mRGDdfFyOPDXNrN9qgoGujW7KjhCRCipec0+hGQM5992qg+NVNfrRRplxCLcV6CLIvVP5jH1819OISt+H59SehEjrdcmcP2O/mo06o1sI7gvCf2hlk2QOTBvJKaEklEywfxVspO8KidWx7PMpwdcLt1IFqOc5ru2s4ycYc8PXA4YMoxyHHvLryKrVD+v2/mfLHB5OC9CDXs9qa2fpDmebFG5gOf//rIOE6E0+M/OJb5lyYYt5ni5icx8El5sj8QPfunpJFbXqzU/Ob3GJe5ud7fPaqckz2R0O3bRUHV5+cyQ21T6S749C1cfNTQx5Uv0vUqM36oaGw2lroW1Ek1WsJR8F2G9Ig2CNsYwgLDbkvb+PKdGX4vZyoToMlJOPqZX/uC+OdTxe7aW14+AkZsv/1oX1nLnl2Cb50SoKCU+FXQl5TVsC7s4FLJTjgS+muznYJwIWa4o+EoMX0666ltSKjOlPO2Wne0V1as6Urm4A1BuJk8XHifIUYuvM/o0EO3OCgWIpec09X4orKbK+5H/J7Pl7VRT6qE9jBUI/a4rHG0KKlhiTcAXTdCN/DaZ6n4J0aC4jX+FXJVnflPEdz21jAmp0kjJCEhgVqFRfGiIQH5RsYtZ4Oc2NAL6dX+W7PBHw8rC6K/pIP46n2aq/gMrfTJdW64EqNw9I5RAS+J1vEG0U6j8oIXp+X1dTw+eWhnhL+nLncgqKjHSgXQl0NHhBHMqui5lj9XbLvbPf2S3yF3Q+urpzIGqs4ryAjL5aHO90cXTqD6KHTlErNv5NbhIL2EVK0BtyjJ
 lFISfl8m
 gTDk05+iRhI0o0TeYyHa6Rjwl12njNPNpnQkDU8xLReMdrndJ1kwohdl1I3Ey31X+IsqSMXtX2c3LheyO3jK3HVT61tXlZpspUsbTrthJzktJd94STGu4kHdRBgbHIgsiW2T2FAa9u3SqVwyXx7+m1KAKnB2gqm8uYWX9obmcwHNyb36vhFfqu3xldXI04Vz1n58iKIAEWEPabsXvzJ/BCY5ZCeODR60gvAUNb9EqRaSCPaT5ExCVC9Byr0UxbBtni7SOVBPxL+16fgk4Q0FP9tPtX9IGao4Sa2gqzkKrsV3B8Io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 08:49, Weilin Tong wrote:
> VMAList splits smaps lines on whitespace and only keeps the mapping
> name when there are exactly six fields. Names containing whitespace,
> including paths with a (deleted) suffix, are therefore lost.
> 
> Limit splitting to the five fixed fields and preserve the remaining
> name.
> 
> Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
> Assisted-by: LLM
> Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

