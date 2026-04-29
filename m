Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC0CFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B446B008A; Wed, 29 Apr 2026 10:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C406B008C; Wed, 29 Apr 2026 10:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69126B0092; Wed, 29 Apr 2026 10:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C86706B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F355C14DB
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:28:00 +0000 (UTC)
X-FDA: 84711822720.02.9A0ADFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D39B180009
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:27:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqYGPDFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777472879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vv5ZLTnJl69Hs5zEFdRwqVVHcdiD2hLQSYQ2J3Nv3Ec=;
	b=vqa7YX5OOUH1eWykf4k6laOHAEYr/qxMBGvoRohT1DbBkvWIngjz/5T2jDTsqR/s9nWN8t
	E/PhaJxFsEEUkjrH+BrOE1jT7HDUxnpGeHzQ+X63g7BshxWu8v8W1q+xVQEm1WR69LvQgJ
	nXXGNBPq3c8bU7NyYqqAKJaGpXf1sjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777472879; a=rsa-sha256;
	cv=none;
	b=tf1NNzWZUcYNYV4RAyzI0/Zw02X9vHy2982Dz0ULJwiLf4eq9ogolDjJJ78ZRmRPtuqRmf
	+WnuxLKPN79CtcjGxMerg9ng/kGYdv0EfB2FbeaAhLA6DVxz0yOKhdue8ILpes0Xkit1E5
	VbnRboy/XszOn4piDOGDEIwIHuqwylU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqYGPDFw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D68643F4F;
	Wed, 29 Apr 2026 14:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA2EC2BCC4;
	Wed, 29 Apr 2026 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777472877;
	bh=kr+IZfpp3YRrfsIWF21skEu3u02zUq6YoI3YRfhgI3U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gqYGPDFwCNDHYUkXGP+yilaRCVVBVHP4VGn5n3ZaRst5NHItojb8IqX5R5/3GqtTA
	 v3tSdpWpoCZbCghaQ7UYCe6wC4yQ/ZtcfcrrOTI+gMEOANnc4DVK5y0NSKs2M+h8h2
	 edNJE44qS+/LJd6VuIUBYDyX1+u70JxPPkxC0ZYBENQan4jujvbPAPtPuiHLxbuHc/
	 o5alZpMXtaox29BLyNdqDJ9+D9BwR/s3lE1TpbTyZvlSNgUkScCL9NfZruGdxpN3rR
	 4ecrqfRhgC7wLY2yPxftZOXOoFbj4wvbIVCNm8bTo7OpHsss6pO6U3bxIybzmAQFdV
	 sCRyn16H+sO6w==
From: Pratyush Yadav <pratyush@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org,  linux-mm@kvack.org,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/4] selftests/liveupdate: add test cases for
 LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
In-Reply-To: <20260423234753.3873095-3-luca.boccassi@gmail.com> (luca
	boccassi's message of "Fri, 24 Apr 2026 00:44:21 +0100")
References: <20260423234753.3873095-1-luca.boccassi@gmail.com>
	<20260423234753.3873095-3-luca.boccassi@gmail.com>
Date: Wed, 29 Apr 2026 16:27:54 +0200
Message-ID: <2vxz5x594z9x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D39B180009
X-Stat-Signature: 3rnfxgzzh1nw9figm9jnnd4xuc478cki
X-Rspam-User: 
X-HE-Tag: 1777472878-430094
X-HE-Meta: U2FsdGVkX19SH7ZkC7rF3n18AD7wt3shHfyzHy39RCprgzQIFMvAx1PJBYKtdWcayDYLrNLlPV4Er9I45eEYDoRhAe+SzYQTkRBXD//RPn8OHyNQGa8QYPsMjQKx8SUPxvkP3/8IPHwcH4ZQD0wS1YQqpx64Ta0Zv2BRj/KlhrU9C+AAjAWnHzwY8b9qn6H24z7hOu1w89dxn1q8BwB9CuQZSngrWGCXY6RxKbTStl/ZocfHwZKBG/iara9lBI88p8eS25nHuUnTjiQupW0DVt1ue6asJE2pN4gyMF3WfPpiBNWFMchmAjiS63CPlA2twEz2rfXF/1YcPFaroZ8UtL9EeGYXwRe99pZCCMoHn3PWEXmqgS/SLqZOcJtNBNN6RMJb33QdrMMAstJ6dOLaGuO71zJPP+5oQgY8qT0JWHVIYuxfLsPU7SPYZCTlbNVQ6N0dGxMRYKyL1US8bLUrQlmpMU9ga6KSn1/5t8F0H0K1ErGfBt/tN7zDIXADlt00pmwuBZ6wcsyvs20nYa13d3zyihQ0guBnDIxAS7LlsjPoHcf3Kh0pctTa9r9dEYo0Uh+m5JsSIIcPjk5CMq+yrq5L+Of9UDPRB95TsWJpqTG01gCyLjG/dkTcJWDM0ae7nSdFXW8rwDurbhKgOsimwn/AEuRwXDFb5KZeSSwWKH3yxjJALQAHesiQCsL8+J6qjNKwMydhYrqlKolvbuqGAsxcVH78y/clz4+vjbof+NXvhQ4D8jGtg/kNjXry6W1fR5OeV3LpZ2IHHVBDvqbBLlHmXB9Ztpy/y20LkIilctitxpQ/x2NHb8AO1YkXbI7K4bNtb+L2LYfDB3or+TbNUN1vEuNuQCinVJ8WCkqcci0reUWpi8p1B5QYRK/bT1L8dYlNlI4RPDhVx0e6n3XzBLaNzxXKgaK92fq4jrm1XbQnHoPlcIaU44C92I5JzKDYNFYCL7b2lx35hr4r2o6
 +Miy0Knl
 MC/1feEIOVeRzjAt1AeybhPcmee5peuMlEyoWHtBlOPqRGwat8efqct1clOgb+C4kwiwvlZ33vTvUj5o/yIfTWMwUTukQJIeziAtiLb/VLDXzVr4qVPSi+nqZuwgWOv9Gtn/0c/DILnGlSerTkPo6OwB4F4reRCHZoS/1vNmqkIEmD7mt99z/a6guxNz0vDt1WLUamcisQ2gWOAaQVEUUVdMNZmE2b9cwDMVkC8ZCS+h/x7aG33o2y/jPpsQBLt5N9VniTIdO+86Bp3d39mumGPkm5Cd7kkrHRkn/NlZLtmOilIOizA7Kc/Gs5s0kL8BS7u3eALA5SxDfUtJhun98ZslVFCC+VzNhdtlKrlJ2pHnuLw9dN2B8uBAElkfjoVWqxRQufzux8P+KxKgQiVXSaa6Dzo3rzO3Cz2m8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24 2026, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <luca.boccassi@gmail.com>
>
> Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
> that is an empty string or too long are not allowed.
>
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

