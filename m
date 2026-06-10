Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C579CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A896B0005; Wed, 10 Jun 2026 09:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB496B0088; Wed, 10 Jun 2026 09:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA196B008A; Wed, 10 Jun 2026 09:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9F36B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40EAF160948
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:38 +0000 (UTC)
X-FDA: 84864150756.03.4F8465C
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5744FC000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c5XPJ6uz;
	spf=pass (imf10.hostedemail.com: domain of maltewechter@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=maltewechter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099736;
	b=5yPaY87NTMrZHbO+IYygJgLOvkBYBpzhPkRCD8cYf89roVT3Y7DHUWyUIzq4PoCtdztUf2
	C1G7QFYgE6EF7iHMaG1mWfUAA/Pqi5sndVtbsUth7TffZdTOViv/VR6sNtgIE66S/rkCwk
	gFxdUe7ilN6+stsnMB9OTyu61DZBvmQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c5XPJ6uz;
	spf=pass (imf10.hostedemail.com: domain of maltewechter@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=maltewechter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zrfD1plP1bimcA7C6IrsDX2w89PrVAfDKwGHaQaTOpA=;
	b=zm1nI82LCJRcqyPCwO0wZh8AXtM+ZJwxh+1SUZvQxmVjuv/fl8wAi8/WskJxqqeX3K88DY
	JAP7vEk/1N6UC61QaKbJ/h/hgbIM3w9dlSww61aRAE7ZE8lTUHaCrIiZtbu9LV0snOVkWv
	GK/3BRlh2QQiCAfH/UKJtiLsvezO/Mc=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46019b190b6so5111247f8f.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781099735; x=1781704535; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zrfD1plP1bimcA7C6IrsDX2w89PrVAfDKwGHaQaTOpA=;
        b=c5XPJ6uzjPBvgg7g+oVt0ZOo/aOhGG3mJk0JRk+R03taA1EiUvRKaENwTKtEVp3eUQ
         mdRfCquwwG+IQpGICCkNLwO4CFUegfgSGaeEwGsAg4cMNh+gibvGyUJTl7OGvsWaxyao
         pVvUKrW021prTB4QNyua605YS5jOaBObJMWt164Dcfw0z+FV0UrFJ7qH+D2FzXmpOjk5
         BYhxBloRFCiNS3xik7l6/DEK20Bie06per1VcAkUoWnL1aKq6wD63FtXFv0J0S3I8iyg
         /YqtCtrjSlSGEvgrGLCd7lGJ0N2SbizjGZD2bE+zNFV+gk8w3M1t65W3UKi7MXQ7+JmP
         AohA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781099735; x=1781704535;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zrfD1plP1bimcA7C6IrsDX2w89PrVAfDKwGHaQaTOpA=;
        b=KcBmmEu8aNyx2z/gclkA1wcuERaesarCyYgFhMMPfxZAjwaw9bA8kKL/xu6TdIt/Fa
         m0bdSl8xGxqmIhw4Uuzf6hOejXpFtrvUyF7fOdu62/orV+THW26KQRp9yDjEDyb5SY/+
         9CcgQjsZmc+cljTIJQiTn6z+BJySCqgMjZ5x9+PRoINV0glPdHe0PLvNxLyPIdH3Colz
         L/kvmrkqwiGB4WIWmWjcheJA8s1jvTX/e8B5roru8cp03mmYNJH06xr90C6hwTnozEM+
         cpYrHihOO2K1AVSkKnrir9J03G9xdWF5FJ6zncUZdMoiQTkG+EZUlrWULHfLordclVCw
         VPYA==
X-Forwarded-Encrypted: i=1; AFNElJ+kes2YjLz+gwagwByyj8zpPJHmK1h7dda04Dlg7SYAjctB1TZAyflzKmOXksQO7sGLPpwSOcPJIQ==@kvack.org
X-Gm-Message-State: AOJu0YzpYtav9NQiAOS4oX5cGLB4ROSvqrGoWRyY71JnelrDAvD49tgF
	IWaLQY+UzWejfHa8m6ke2fvLqryJyPup156TS0y62Q40Auv11fQeqyvV
X-Gm-Gg: Acq92OHlbbbCMyKuzaooDf3QmTdMJMkM/dbW8grpdyieF/OAnveidJBWvaS4Uyux82U
	n24ZfTWUZke62nh7Xk7AxKQcvtGLE0b8RNPyPoKi3m0eaKuAQ16GV6bVMeWtES9ctnDvc+0klHY
	qJoV65fWEjsMX/FHhsxPRIsqR2V0olc21QlJZn+bhpHd7Rkd7KHXxMeeARN/JAFaMwH9poUNARf
	cLqP2zcCAASakuBGKskywvNQwuUHi11BU1G5MDt1+mUkDqRR3UR4KRFj8Kx1AFjIO3oNSgtu0XT
	6k50xJRBehM6a/M0sZG/q4pMyxZeIp303BA3UqHM9JaCd+7lTGfcIMNJI4dw1EyxmEpI36wXdky
	nsNBnSGjBTC/4X8/IgHBf9Vsntf72HDjaPdpn05k8HFdwhmQ4IyhjCboWvD14X2DK6HTj7riA+Z
	Zrg1E+drRxLE16s3tSlFMriag1JJ9mkSnZU7BDI6a6DKMQaG8S1bXmOmxEOoRMRjo6C+M=
X-Received: by 2002:adf:e014:0:20b0:45e:f29d:d438 with SMTP id ffacd0b85a97d-46030618a38mr27777125f8f.28.1781099734405;
        Wed, 10 Jun 2026 06:55:34 -0700 (PDT)
Received: from localhost ([195.100.225.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcde3sm73903398f8f.1.2026.06.10.06.55.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 06:55:33 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Jun 2026 15:55:32 +0200
Message-Id: <DJ5F5T5UIXRF.IVVHFP62M2Z8@gmail.com>
Cc: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>
Subject: Re: [PATCH v2 23/83] block: rnull: add discard support
From: "Malte Wechter" <maltewechter@gmail.com>
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Alice Ryhl" <aliceryhl@google.com>, "Anna-Maria
 Behnsen" <anna-maria@linutronix.de>, "Benno Lossin" <lossin@kernel.org>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Boqun Feng"
 <boqun@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "FUJITA Tomonori"
 <fujita.tomonori@gmail.com>, "Frederic Weisbecker" <frederic@kernel.org>,
 "Gary Guo" <gary@garyguo.net>, "Jens Axboe" <axboe@kernel.dk>, "John
 Stultz" <jstultz@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Lyude
 Paul" <lyude@redhat.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Stephen Boyd"
 <sboyd@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Trevor Gross"
 <tmgross@umich.edu>
X-Mailer: aerc 0.21.0
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
 <20260609-rnull-v6-19-rc5-send-v2-23-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-23-82c7404542e2@kernel.org>
X-Rspamd-Queue-Id: 5744FC000A
X-Stat-Signature: f5k77na54ix7ub9ao3t9gnyxksctbdkp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781099736-108261
X-HE-Meta: U2FsdGVkX181syTtaqE6ZewlfFMZ15tufSstVR5FWbSvYemfb3vJ7uYP3DJrnDgQRfjbZzWLn+DuNzDMoV2lOK/dxEWPKGcsgAaGPOAypnWrzL0YPz6s5JtZNE1RaZ+FeRhar/EKO2n886vYDkpfHpV4vXBZeHUlUWWcbP3171MwNotEPwF/LXH3BdEYVqkUyqyqZDJRnDM5QPyj7DCBBBQkw3FbHvEq3MEx8U5Frb3IGBJgAKFrV4D7j2yIujQ0QODxitbuXZ4dg4tbzbk88S8LN64sCueEGSVPP5HIqlNPwzEdUnKDM78YHs2XAGk/cvjdXYQhaiJMk8nd9XW7w9qEAzWT3CaV+OP56uQ4L3v4GPYVyyYQO231YgYwPxkmrSpQb3XOx/1Dig5EDnZhXY5yRapj5A2xrrMuX5xdSuxyCc2ASxgRV+/YAE3oCM7ikeE7vZWYb3HZjnnL+4W9xlqFHvf669K+1scnUvG5yhqVVGC4MLKeh4zO2uRKyqqjtmgexU0/7T49neerrGBSN/PiUcOk7iLx6MfToNaaZt2X9JrtA+X0q7GSLDYjyBd9N+tvrGr6lWM/l5DD2V7F7NybXB8vbPNnx/E+NYSIPATVeQStj6Gf9zbxdhmapDIKcep0S/N7YV38aQsxZ+i8nD/IG4Fb0zvWtHzDbMs90Dy3yK6x6E08cUVoZsVeFGcrQd/0OzjByt2vpf43L/eGtp4TEv9fCnybCO21OI8W+xPdASG9yiANt99cVMP55ZbwSJGR6sbIO7sK5F25bx/yGBWFGcU9njdaLauqfEhfy5GOfuwTP0ngLtTkVLUsEEiX2v9ckDl+1+VS2TtPqjnOJN+KUO7wgV+qyBHE40siLiLU50reEKtupyyXWyXHkdff7BAJV/jluxlp6IEiQVxhRnWEeIB2RLNvB0cuR2H8dLSU22JyJkvOt80fxAESnLOF4ioi2MykbNrIxmr5rOG
 6tRjuwx9
 U9jGmUmDQ1aa7WBLcLhDdZf8QMD23q6RBmaszT7yus/gOSxKWYm7k954bAePQELx8LUOiOu0XaY25LMmLOyJJqiAxf1DU6IlI090s0o+oJ1VZiKQQM81y2809SfGfzl3x9FSlTgYfbZy/6atFtvgln5aFqYYa9+R9nKS/pozVNQ1c0lSvvAVJ0wbBsxfA6pCzAEQL+uJLNgX0mgBjJCd5UNIQ+nuCSnzajM19UUWN45WIAvX9ERl7h5kzewTk2r1baVS5LAn2fNsxOxCyuMi0wAA+A01DvOf6GIJTOF4mR6oJgiEoLYObH71sRVQzME7FwvZSADJ6UgTJJ3jwFsR21iXRiKq67SmvF1938W70IZ0xMk5lup45xRX4wg1IYD9o9rxn1tbzYbpvpofUfvZJlpZCW0zZ6t4mNKNOKUNvr555FLtKI4NMiYfeLVF37BMOLvhMAMtoFvnDD3FiFWALbJeXYlqz0DIJbGxQubl1wSf5HI58uFEDcxu3968DD0GFkDUGMFnQuoRLYlpx8jfyKVP2S+qonGMRpJjhuWlbmG3e2WB+zW9+mpONlwrdj4FISsSE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 9, 2026 at 9:08 PM CEST, Andreas Hindborg wrote:
> Add support for discard operations to the rnull block driver:
> - Add discard module parameter and configfs attribute.
> - Set max_hw_discard_sectors when discard is enabled.
> - Add sector occupancy tracking.
> - Add discard handling that frees sectors and removes empty pages.
> - Discard operations require memory backing to function.
>
> The discard feature uses a bitmap to track which sectors in each page are
> occupied, allowing cleanup of pages when they are empty.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  drivers/block/rnull/configfs.rs |  15 +++++
>  drivers/block/rnull/rnull.rs    | 120 ++++++++++++++++++++++++++++++++++=
+-----
>  2 files changed, 121 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rnull/configfs.rs b/drivers/block/rnull/config=
fs.rs
> index 2f3fa81ea121..e47399cd45a4 100644
> --- a/drivers/block/rnull/configfs.rs
> +++ b/drivers/block/rnull/configfs.rs
...
>          }
>      })
>  );
> +
> +configfs_attribute!(DeviceConfig, 10,
> +    show: |this, page| show_field(this.data.lock().discard, page),
> +    store: |this, page| store_with_power_check(this, page, |data, page| =
{
> +        if !data.memory_backed {
> +            return Err(EINVAL);
> +        }
> +        data.discard =3D kstrtobool_bytes(page)?;
> +        Ok(())
> +    })
> +);
Should it be ok to set 'discard' to 0 if 'emory_backed' is not set?
In the C null_blk driver, 'discard' defaults to 0 if 'memory_backed' is not=
 set,
it is also ignored (and defaulted to 0) if 'zoned' is enabled.

Best regards,
Malte

