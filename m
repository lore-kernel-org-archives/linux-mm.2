Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4BB5606AA69
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XRzd7/yo
Received: by kanga.kvack.org (Postfix)
	id 19B206B05B5; Tue, 10 Nov 2026 10:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C816B05CB; Tue, 10 Nov 2026 10:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B206B05D2; Tue, 10 Nov 2026 10:06:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DEEE76B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:06:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A455C08D6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:06:27 +0000 (UTC)
X-FDA: 85419535614.18.12614B8
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C96E18000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:06:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="XRzd7/yo";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794323185;
	b=hAhhjFm6cMLSK+wRX3qY9oAliUmz9dvq/y+Zi2XI59ofZe8c5vCzbFxCdbwiiwmdhHo1ha
	fShhrAQQE8UqB+83PDJFq/yhVEUiDBV3xArTN5slZrzd3lCrbbErKUngX/v7DplN8dbpWI
	+8nhAImfeu7YcjHTcM5jnU2wBkNBtM8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="XRzd7/yo";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lerN1oA58W2Z8Jb9p+WACSxu0UlPvw3XxQk8+NissT0=;
	b=4xHwIzFXxA06kBn0nHw+MQ2jZXkeAxSPkW6mByaNts5miwkbGULfGXCK6/AQdztIrvrRj1
	UPbqkPfbO4GoKPiVOmWolPNraDcGqeecnFJpxqrWElr6GXVDTAOGgn3oZQCBCkHNeq2soQ
	u7mNaNNLq2mMhHb8tI/eSYBvEjgaL9o=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so3020838a12.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:06:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794323184; cv=none;
        d=google.com; s=arc-20260327;
        b=X0rF4xpVbm0j923NG2pio2BbDwLdYvBTLjsVdtSUJzmqs8yoA9dh3tDunXhRfCU8ln
         UrLhjpXAQwiLLUbDKlwZ5Dn+yhyNodqqby4RDnexg/RxkJ8IN6RNIvy5njkmLuvLSQfe
         lhm0w59sALJ8L/YL0dV6Bdn8xgFtw1DuxUnSZfTxkBSOocVQFuZ9rg+u50rnDRVoBie/
         8UXoQwcyGLZ28c4QWYDBRLhKDOywImP6tP+svBFzMphIL+Qb15jR3U0ESy/z9Pi9UaBY
         5KSaEQTqAwcZq3EYkXDo56rxCXa5QG1BFGkqN2Wh2VJr4T2sy0eVUvREpsQcdJMUsDlS
         Eztg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lerN1oA58W2Z8Jb9p+WACSxu0UlPvw3XxQk8+NissT0=;
        fh=TfsRAWX/ht1rMuZn760DO1lXhL9IQuR0eYbeT90cwko=;
        b=Eln4unBo3FbwRPUPMUkc6whRgQprYirc9mkxmFLFZZlhfRzDf73xTpnMaOy0R1cY4R
         bkJ4r4komKP1IGI0SjvHyKXlamkCpilIwBDj257LZbqOujfNJFWOA6T3HolKKDw+6J5/
         LkMp2jqrqwjXpMk6xocOF3tACDVnVSFlXfSafFoN2I77qGJ2foXHyfUPjhqeOMrM36pX
         SnjkTZGr4Y/DEqyLexv8U3syiv0SslHn4E7g2jCuiSt2fuszQuPoO3TDbLlZEPLpCvzC
         JJT2CwcOxr62W3zRsRl+ID54+HDS+iFYfNliDXsHOvAhJ8f1KEIHuCICaVlNevG0j/2p
         8zhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323184; x=1794927984; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lerN1oA58W2Z8Jb9p+WACSxu0UlPvw3XxQk8+NissT0=;
        b=XRzd7/yoc7iOIBJpQro3BO9ytsyYNGL2bKju87JZI1HdGFIp0/EmxgtpqMXEfD6TD8
         O3IceE0s30IHev9HMD2ReGfCfTQ8oPvICHQTsq6bmWRt0zVA/U3byRXFxMXyVVF4fDRI
         8WDPn441XeNpRKmWValrNJLzf3bbLxuEK4C07HmSMMbmgeZ9OdjhsK6tfpAwpFM1WO15
         6+HqOgnwhMPnNfabY9UrrZ99dKtKVJbMAYQgSmwFYca9M8LALQf/kUY4aDnPNLnL2vll
         d9XBS3bm7WbyDLI0NLTXvvEEGiFVfA8f5Y3s2KjmqaRrfUsKaUHJyrWxBBudN8Y8t7L7
         raFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323184; x=1794927984;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lerN1oA58W2Z8Jb9p+WACSxu0UlPvw3XxQk8+NissT0=;
        b=uNRl8UTVjhNEK8OShpmGmPUTp76klulxOdu+g7ab+ntdYuozEnR/1MzCBnHQ6p/Zn5
         ONuLSb5fsOdgCPQFgADGN00W9XbbZk7kJQSY1NBgvFJ6pcQ6M/GYYUBw6EQdotWcZb0m
         bCqOlNOyFqA29T2bOa7/XhTgf4UmgXEQGV8UPgtOGLuNMm+10be1CGL+EaEtQA0cRXiW
         tSU47yGxqB1zxccP2Y/cHidrCruV6mwlfvkNAgdA1neXiRXorCtXnNla3YRlu2DP6HxH
         VWzNAbF79PyHvNzm3ylfmqmOLHSavxAfMGwEPumcz6DwHPs4xpjGcUHmBF7PdmH/SCrd
         VLBQ==
X-Forwarded-Encrypted: i=1; AL+hErHx//RukTJ/W1yDpWDncDRtEh68lTlKR55iZk4GDl2hV/cLWWJvityHvHNNXzENGuIQbFNpxb8ruA==@kvack.org
X-Gm-Message-State: APuU4Z+8Msv+GJQ/QoZGX4IxLREPWNZ6rFyaT0FufEjUa/35nBmU+SMY
	HYwanlL3GupUwlTvdgNt0B4uqfKuXC1aRLYz9VxryJxZs/58+zC91QQ3vBN7fwHfbPsXHIF9pJO
	ClJtTtEF0G0fiVJAb3GfPtrVtS4DiTzb/jqDszCWgXw==
X-Gm-Gg: AYBFou1MGCJ1Co80DGcWM6Ty5xorLLKBj/xDbKTT52LohphJmErjTZCD1L/0CtujZ+N
	hEoHMprwTsXElwanzOUDO28W7e2YhpXwjV1CbSINt5jCjhG8hwENsgwQvL/+FcVMK5GKFTAhdOf
	Q3CEOqRQ8CbqZHY1HTt8zLmzVeLZISZUG5i6G9q3EcL5ucvSFksLk5xQqbDrsP4EEUJRNErEh26
	i4mylsVFELoCDA4ToN9fH88PpR98b31xOD4QZKcq/q5lrEOG64h3IVmsKL8/peCngaVMZX/ejut
	/+AD+z//DCd8G3istXqLONOZZMOX1lFzD1bXJKGzRgUsmeNaN+ZzGyWe0Q70ohMsfw9FB7aUoQs
	CICuU6evlOnHnOGLaHyw6zN9pFju+UEe4kx044u5c7RNNY3GTna2RZpiwGDmYCMUd4K93WW9cS1
	u9ASVA990iFJixk3fYLRAkwK9ZsTW3A7DSwECUeY0U4BpAEgswsqXiSO2iX+231hOZE7d1cmvCk
	g==
X-Received: by 2002:adf:e011:0:10b0:48e:66d0:664c with SMTP id
 ffacd0b85a97d-4982f2b4b58mr4108324f8f.15.1794322843878; Tue, 10 Nov 2026
 07:00:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109-zsmalloc_stat-v2-0-caee41684aba@gmail.com> <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
In-Reply-To: <20261109-zsmalloc_stat-v2-1-caee41684aba@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 08:00:32 -0700
X-Gm-Features: AclHuK-XBZsgATZ4npwXhUnZcAjEJ-IievOGuoTbtipAN4Uucan3rCpbmZ9SRXo
Message-ID: <CAKEwX=M6dJMccGcDqp2S-66cbegdivnB6MqQRj6tQ2u18UH62g@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dsufip3san63uxwbezf3zh7htd5gjudf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C96E18000F
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323185-158250
X-HE-Meta: U2FsdGVkX1+WJr4a2j/tTbL2poiWBTjBKN4GGyDWC/Inbfv+f0Yd9GH6Thre4b8mvm9OssMt5RJppxwu2XrUaxHcBxkgr4WKqcdOi0LCmZqP6TfoTJlGKmZa7B6QSlHi7HBbslu3WTmFW+n5kf1PXQZSrVpFhY9P6f9Er1XFxd5ILTekyt5076Od5aJscMl35rYMyPOtQj6nO/kSFQPos3u8NN5FPVfGAvQPFsaJlQLibXJK47OeVMWv9lkoVFqyCwJxu5avbPxGSXMlavzZB20npjPB/wD9UwsIU6/hwAnKI6t+PFqd2yLIUfnLLpJTQcLKfArg3hQz02eWB2VlX5CEBAAx/K2tFo/mD1/5woA9C/22lrz5sAS1OKkHodFGFwA7iXuj9giTcu9y5XlNgZikoACE5Ws4va28AHXKf7oN/j3nMcez+fW89LuqLdkCWFb0MuI51gY9B+nzAqvsUTMVl2db4v+yjgZVQdtoDsboq22aNhFzeEt2CnP4GIn6aqDqywBagpE4FqZwbtevqafFiYtvwSI8oGU67QFjDiKX4uNWwDMOIfN/5uk+jFMiXtrDdA9y3uWDXoVf9GYk3Xznas8/LMdky8U7OUmTd30bbatFElrkfDZeT+xRSJnxcE1/lUHFMY/B6TVrsJCv5M+YhQhOsT8Mmcqs9YOR0ji7+Ly3LKjUqHam9RAANBiBTFVWFnqRCaNM7y3+Osz+qx5MBU4nrBw/LXUgUKbhgl4L1AvIxyuWng3NKdjPVw4QLjR4N1vgPJvkfbuwpzFOMLSPInKK17kIyG5I0lLYcZP4qfzE6GMoPxI1XeW6rfnZxznF3hpe2gFXjKowl4Dso7m0pWd4hSB3qJfcJi6Nn6dvwhsrRjL9O8sxPp/PrYUPdXw4uehX7YEMYzJJTT2VxqJ/nLGR/pNHfBMGMqoBkio1B6JkH64QMDcQD3SamQyoCh8N8kTB8S1BJ4fhR2l
 TqOVtR00
 6OAQFVwJDS15YGQiQ9yis+4Nbaw7bnm/jal4sCu82tzB5EO+WvKvO8Cs9pSPefaUE2gbQQzDeKM1cyhjkihYX1a3qPtJ/g94s3REJz4c3CZ87DvJcUgHCjHK+/CRd5QIrapmWf+gQM/JtF1U/K3dLl0RntehL4hzKpIt0j+Y50lhyUVv0wEF8BzcgLcVylBleWDY0hc/E/WuyJ1KTNbsRMR91iUC7Uz/9MDYF2CuDBzoj2lXbi1gFyuxM8FbFIa++Hi1rBWYKK5ECGgy6Qp6pJawBw/clGGGf+Ltx35IzyhkHlZC8tBhnjv0Hjx6MhpvTGDUwQYIgUIW8G4lMndtB+LW0OVCW5vVmcKtKbwfxI8nJ7J/rXq1vshiYPW1laNS1FQYdMyJmxkjK8646bAJdZikj/d4Jre6Y4mW9O+mHh2hTcMCtUXhHolnme1xfSPjwrsOu1jM46YD0uaZCjeotRNXllhWAgoCZV9qrZhRssBMzE/bHPBUEk9OZhcE/F03oz2GMLTcOKh5kT5Giqn6Wr7IGyJnDdXNNPwAJWnbEvSm+B+t7L/4xIY8UpgP25PxMdB89hTE8etQzSc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:59=E2=80=AFAM Xueyuan Chen <xueyuan.chen21@gmail.c=
om> wrote:
>
> CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> counters are updated regardless of this option.
>
> Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> stubs when CONFIG_DEBUG_FS=3Dn. Skip statistics setup silently when
> debugfs is unavailable.
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/zsmalloc.c | 33 ++-------------------------------
>  1 file changed, 2 insertions(+), 31 deletions(-)

FWIW, LGTM:

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

But I come from the perspective of large(r) server machines - I'd wait
for the feedback of embedded folks too :)

Sergey, how do you feel about this direction? We've run the stats
collection (even before we select CONFIG_ZSMALLOC_STAT to expose the
stats to userspace) for eons, and it was never a bottleneck AFAICS in
our fleet...  And the stats files seem trivial, relatively speaking?

