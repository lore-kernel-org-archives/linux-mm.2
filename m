Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF38F54AC0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 14:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B2C6B008C; Tue, 24 Mar 2026 10:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662F26B0092; Tue, 24 Mar 2026 10:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52AB56B0093; Tue, 24 Mar 2026 10:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38FE56B008C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:17:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E64C993A8E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:17:15 +0000 (UTC)
X-FDA: 84581158830.20.0E9EFAA
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04198C0015
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 14:17:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oI/W1q9k";
	spf=pass (imf10.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774361834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BW4M6zPgEY93ifgR0CoU+SjPYbfx9tdqVjEeIASu4bg=;
	b=HBzu/USaKULdQ9Q/JRn4lChWuAcC5qOLCDYU6V1vrua+yC8iD9rG2PkgsWd82tBkHU0/q8
	kC4c7b2MFsmtkCKYlr7OZRyur3OoraRMfix9U59sgowBa0fhzJbo/AwaGI6C2hx8k+/NJv
	9QuYouajBij7VQ6n71w0f5YPE5EtTns=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="oI/W1q9k";
	spf=pass (imf10.hostedemail.com: domain of demiobenour@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=demiobenour@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774361834; a=rsa-sha256;
	cv=none;
	b=7pgQoA3guJYlyw0n+CJCOTGA+S49/gtLV6ptUENiTQ6vUcUCMgxP8la64sF0cPxHvI8qp/
	M37k9ofoS2x16KnAc3NLet8eC0DcR8kdjuqN9QSDTSktfDo5Ra/uezgkog0+aecjOdPaw8
	WT8IndHtpZf2ofYXCH/geZAWBmbj9Pw=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-79801df3e42so70008867b3.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774361833; x=1774966633; darn=kvack.org;
        h=autocrypt:subject:from:to:content-language:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BW4M6zPgEY93ifgR0CoU+SjPYbfx9tdqVjEeIASu4bg=;
        b=oI/W1q9kblMYr/c9Z7lVTrLIJG96+5F9FuOW+Sw5vuFcQzdTMc2r/7MU6Inr6PaSsk
         nPZGJVNV9MrTMkW0mvAO99z14r9AWsv6lerqbfgYXDIG5Q4REwAfWbMAVi73dYJaFXLp
         lY0l4l7xaxhOxJVwZPpsWeOERExhi0LQa3K61Bl0aVJY2Y96/O0EGlsd6NflGGOKk+9+
         syrgGbDwWCl98UA5QL4Op+rGsoXNpNPxvH8loe01Q4L2lZ09oqwBfxv0+zluhzqwVuQF
         HkESHLQR1NcDZZq6jz/qjuq4jseYPLj4Or4jRCbbeXdseFnGiJXbjVjlob5icF5XZa1M
         WqyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774361833; x=1774966633;
        h=autocrypt:subject:from:to:content-language:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BW4M6zPgEY93ifgR0CoU+SjPYbfx9tdqVjEeIASu4bg=;
        b=jbWCYZrtwNCYUXiucgAL6Li4ISk1pk2EK8j1+Zq5yOD8RanlPQdjIym3d9zECJAnNP
         ZkPCL4zpqN68oKR8O6uQkRmr1c8El5ksaDVVLo6Un5+ZMD2PGWJjIJqtzUxye3UaaWkJ
         +42PeumcWrolR+bzqptZ+eHsIbDNypkCOMXxsz35xGNnBBiqQicpIkGqIv/q2dr7+Lcu
         9xeqn7xFKRVfxDwzcio7ovcfUsrviHm/l3Z013jS+KqBII1glK9NkkKSl/8jixP3aqgW
         i7PNEjS72PudEMm7i5MYYdZmaKgtTQkfZaV0+Wt3+bUrt4+ydLssnCGuh2kutgFuxJ8n
         vyhg==
X-Forwarded-Encrypted: i=1; AJvYcCWN1jL7FVZgRRWEjtHWggyxFLTDGqKydlJNRkWC0Im9EMHFcLKpMZq4sHnyMh97XZCMUivqDquEtg==@kvack.org
X-Gm-Message-State: AOJu0YwmMR8UeTQf4kDksYRQhWgfJTM+oxB9HCoLXUqi1X08K94uPwI9
	Omg517HoBVbkh9DedZ/cOh5gMHvl9ybSEb9hWAUeeneD5fDN2bwOG+QQ
X-Gm-Gg: ATEYQzydlWjKI3zLPdNuTiYLOCp8rKOCCn8NeJxjD6qDa11D4yMOyq8TH0j9E7GzFAo
	XcDsfML0jP2tII9U2VlRBsHZXoI6L+QXJIUnjia8EZnqS7p5KnptjFtwqIs9iMVniC6Yx5bEYkm
	C0CUEIDOs00Ui3arIhq4b7+nuSm0JmrtpArAoE+KBNFw6gy49Wh+OdozUr4jazmskBJA5tExzjq
	IChXzcrIGj50KFgDuTWt2CBN3ID3r90fiYoV7jvD9EiZdSVIERF/AwbhSBukcIiXJB1dQy0cKjY
	V8gHiDIFWrqJXxB2VUZ6tkVPSxECBlk3uQtDQRe+CGrU06QgnUpElNtCHRCCjLvzn3CxQIyPKp8
	W0HS0WzixlxFh6x1eN0BlnFXqT6bteaZlfYfvlthIG6Gigb0cPGHDHBbYvH5q8hEcf6UsZOGfzt
	VyngdVjbBTw5r8hju/PYSX5I2o9VJRs6cwltilBIpxgF9sBEeexrcKBB6pP6zmQAPgu+h/kAXXf
	yTGAmzyUhy5duCDk2KYpvLsScZEKphg3LQQV/m593MFuyVUKg==
X-Received: by 2002:a05:690c:f06:b0:79a:b0d7:cc45 with SMTP id 00721157ae682-79ac2e5e60cmr35796827b3.3.1774361828342;
        Tue, 24 Mar 2026 07:17:08 -0700 (PDT)
Received: from [10.138.34.110] (h69-131-148-49.cncrtn.broadband.dynamic.tds.net. [69.131.148.49])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a903a3866sm73692937b3.6.2026.03.24.07.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 07:17:07 -0700 (PDT)
Message-ID: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Date: Tue, 24 Mar 2026 10:17:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Jan Beulich <jbeulich@suse.com>, Val Packett <val@invisiblethingslab.com>,
 Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Mapping non-pinned memory from one Xen domain into another
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------8f2sQR9VZFE00mFmOfKmxw87"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 04198C0015
X-Stat-Signature: qr8eat5t4rd5jk3zmzpcwcbz1jk6t1az
X-Rspam-User: 
X-HE-Tag: 1774361833-646510
X-HE-Meta: U2FsdGVkX18AZKjcWN4znqLSJskCZRGFWRt0agJ8QOAfNOkWBT+dgZ8pBEYAu+33MJeYqbg/WTT9C30LEOyZs7B3vYSIZTGmI9C0OZAtzLf33PByEDf9PAeS8l9NiVA0ETtCNsfIGCa6Zqlj2WkKJ/gxCO7UGDe3CwIizCu7HMy4ms0jUH7MY0GzVpOIocLURmaU9F2rfg+s8EvI9hXMgfv01fKKhoXCwAFYft/ByKqkRqGuareXdY2bJ9PfKnZqRaRxy6Kasrkje/rotI50JxfM5RL7rJX5dHV5PmbELOooHFZbwujAUe5rfuRvm/om2Fm2XJ+BbvJaTeanyWQ/YeNOl+jUHg2iUcmFCtBgUWcD9tR00GH3yyH8LL8g60nrITIwJ21QOsr6q+ufe0Gtj0lXIQoPeW6AUnWWztwiGFV+nKboVMZGc83tnW9ItjiLJB0ciQJNxjtHjZy2fRWZF5l8lv8Ok3jL8WwAgT2j+UPswW9UYhjosyx69tttaBqhHJYhSAQk7IW4tefdA7z1ZyZvd0xNkvfcpbHTzTsiAZmx86nqWys6pAxBsLCOthRalNjKOvQsyp3Y2GXKCcwpO2KIJw1Ni05LippMe5KaHo0RF0hrWkuSx49FggFudLWt+AS56LP+ul5tVvUc/yTMpy1ARS+3t1Rr4Pmk6hXL+ItcZTWW/raZw/Q4aAx9NjnNwZCBFLve0Dz2rA6w4YbolwhpO9BM0XejQV4h7JqmNH20VKKz00F1JVKh/BbJZ3iiGyR4q4Wi7CTfERwzhv4G/o9iHHVUnhtZBcvODBb20YBx59NOtBsykMWKwJDQr+JcZ0pSZ1EccbFFEz2IUJ+od0LooyLu6rfZtPazynuWLNbm7GyE6N5fUDFz7YmBxLoeOyShfXM9II2udnY+mVuKp7NyM4qMx5Z8mlKj65abzV0DBBdUU7tucZ4HXeevBfWFzbNy1a/JdpM+6aHcJx3
 PTOUDHHC
 hDDnANrnH3Y+289V6kBrSDdl6ZjffOy2SnndKD9jZJMOZd0a54xtAXTsSDLEB4+SSf/m5fjdf3bSU21+OIzvUssXdTfXOM00vVNpdOuTF03plloZ+n5mMF8weaTyw5IqPhrjadskJFo9ybGqX0eQ6opHaT8sJ+NenBs24s66AneQ1WSoF9PaA002MRhypG8pa0wYw/FZ5FxgcnyH9oroCWQDijjbamOa62cp6nIj744MQyqGACz267Bb5DXpgQ/lckjWXu26+ytVhhEGQouKEBWj09ZnZmdxLJ3pEi/GlJALcdkRz0wPpwVHXZJxv75PyxkibDZejcA1p2gNYUt8GMZlAkvAeiw2oVJQKWxhLN+A7VK5ceNrLVw2PsTszvMnTR2O46cXFOvxDpvLofqXixY4PWYvzz3QR5d55ZNxq+PYkA8sRrxAkH8pFDfouLVhJ4560mL5IeN1zeqewLjwTvomG5TS6lGARleGmJYyoYKrhgcIur3ywytZIw3qB+w7KxuPpgdlF9g+FeJLEty9NGIMtSixLPORbNp/mJaekhs4rTasF6Jkhy4hG6kmfV0aYei0uXQqbs0dOqbeJvrMhLAgu0SfQ3l9h4UZQO71asqgXvseUaHHc2ZhKAvKw6dDKQRDHtm8Ingk9Um5c/ddJK5nU4ISq/gdnc0Ql0aiTHyO6rt/x8ZXTq7kKYL3VlG0XdWahL96+lHeHmVIPXowoaqHidwOJEkERzDEcnB52vWTVff3EDWWLJG/1q0FhljUpnVvc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------8f2sQR9VZFE00mFmOfKmxw87
Content-Type: multipart/mixed; boundary="------------F91oUXeotTThnqMOJixIRipF";
 protected-headers="v1"
Message-ID: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Date: Tue, 24 Mar 2026 10:17:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Jan Beulich <jbeulich@suse.com>, Val Packett <val@invisiblethingslab.com>,
 Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Mapping non-pinned memory from one Xen domain into another
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Autocrypt-Gossip: addr=jgross@suse.com; keydata=
 xsBNBFOMcBYBCACgGjqjoGvbEouQZw/ToiBg9W98AlM2QHV+iNHsEs7kxWhKMjrioyspZKOB
 ycWxw3ie3j9uvg9EOB3aN4xiTv4qbnGiTr3oJhkB1gsb6ToJQZ8uxGq2kaV2KL9650I1SJve
 dYm8Of8Zd621lSmoKOwlNClALZNew72NjJLEzTalU1OdT7/i1TXkH09XSSI8mEQ/ouNcMvIJ
 NwQpd369y9bfIhWUiVXEK7MlRgUG6MvIj6Y3Am/BBLUVbDa4+gmzDC9ezlZkTZG2t14zWPvx
 XP3FAp2pkW0xqG7/377qptDmrk42GlSKN4z76ELnLxussxc7I2hx18NUcbP8+uty4bMxABEB
 AAHNH0p1ZXJnZW4gR3Jvc3MgPGpncm9zc0BzdXNlLmNvbT7CwHkEEwECACMFAlOMcK8CGwMH
 CwkIBwMCAQYVCAIJCgsEFgIDAQIeAQIXgAAKCRCw3p3WKL8TL8eZB/9G0juS/kDY9LhEXseh
 mE9U+iA1VsLhgDqVbsOtZ/S14LRFHczNd/Lqkn7souCSoyWsBs3/wO+OjPvxf7m+Ef+sMtr0
 G5lCWEWa9wa0IXx5HRPW/ScL+e4AVUbL7rurYMfwCzco+7TfjhMEOkC+va5gzi1KrErgNRHH
 kg3PhlnRY0Udyqx++UYkAsN4TQuEhNN32MvN0Np3WlBJOgKcuXpIElmMM5f1BBzJSKBkW0Jc
 Wy3h2Wy912vHKpPV/Xv7ZwVJ27v7KcuZcErtptDevAljxJtE7aJG6WiBzm+v9EswyWxwMCIO
 RoVBYuiocc51872tRGywc03xaQydB+9R7BHPzsBNBFOMcBYBCADLMfoA44MwGOB9YT1V4KCy
 vAfd7E0BTfaAurbG+Olacciz3yd09QOmejFZC6AnoykydyvTFLAWYcSCdISMr88COmmCbJzn
 sHAogjexXiif6ANUUlHpjxlHCCcELmZUzomNDnEOTxZFeWMTFF9Rf2k2F0Tl4E5kmsNGgtSa
 aMO0rNZoOEiD/7UfPP3dfh8JCQ1VtUUsQtT1sxos8Eb/HmriJhnaTZ7Hp3jtgTVkV0ybpgFg
 w6WMaRkrBh17mV0z2ajjmabB7SJxcouSkR0hcpNl4oM74d2/VqoW4BxxxOD1FcNCObCELfIS
 auZx+XT6s+CE7Qi/c44ibBMR7hyjdzWbABEBAAHCwF8EGAECAAkFAlOMcBYCGwwACgkQsN6d
 1ii/Ey9D+Af/WFr3q+bg/8v5tCknCtn92d5lyYTBNt7xgWzDZX8G6/pngzKyWfedArllp0Pn
 fgIXtMNV+3t8Li1Tg843EXkP7+2+CQ98MB8XvvPLYAfW8nNDV85TyVgWlldNcgdv7nn1Sq8g
 HwB2BHdIAkYce3hEoDQXt/mKlgEGsLpzJcnLKimtPXQQy9TxUaLBe9PInPd+Ohix0XOlY+Uk
 QFEx50Ki3rSDl2Zt2tnkNYKUCvTJq7jvOlaPd6d/W0tZqpyy7KVay+K4aMobDsodB3dvEAs6
 ScCnh03dDAFgIq5nsB11j3KPKdVoPlfucX2c7kGNH+LUMbzqV6beIENfNexkOfxHfw==

--------------F91oUXeotTThnqMOJixIRipF
Content-Type: multipart/mixed; boundary="------------0pKE5AMCA0EH0rScO9pP0tYQ"

--------------0pKE5AMCA0EH0rScO9pP0tYQ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Here is a proposed design document for supporting mapping GPU VRAM
and/or file-backed memory into other domains.  It's not in the form of
a patch because the leading + characters would just make it harder to
read for no particular gain, and because this is still RFC right now.
Once it is ready to merge, I'll send a proper patch.  Nevertheless,
you can consider this to be

Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>

This approach is very different from the "frontend-allocates"
approach used elsewhere in Xen.  It is very much Linux-centric,
rather than Xen-centric.  In fact, MMU notifiers were invented for
KVM, and this approach is exactly the same as the one KVM implements.
However, to the best of my understanding, the design described here is
the only viable one.  Linux MM and GPU drivers require it, and changes
to either to relax this requirement will not be accepted upstream.
---
# Memory lending: Mapping pageable memory, such as GPU VRAM, from one Xen=
 domain into another

## Background

Some Linux kernel subsystems require full control over certain memory
regions.  This includes the ability to handle page faults from any
entity accessing this memory.  Such entities include not only that
kernel's userspace, but also kernels belonging to other guests.

For instance, GPU drivers reserve the right to migrate data between
VRAM and system RAM at any time.  Furthermore, there is a set of
page tables between the "aperture" (mapped as a PCI BAR) and the
actual VRAM.  This means that the GPU driver can make the memory
temporarily inaccessible to the CPU.  This is in fact _required_
when resizable BAR is not supported, as otherwise there is too much
VRAM to expose it all via a single BAR.

Since the backing storage of this memory must be movable, pinning
it is not supported.  However, the existing grant table interface
requires pinned memory.  Therefore, such memory currently cannot be
shared with another guest.  As a result, implementing virtio-GPU blob
objects is not possible.  Since blob objects are a prerequisite for
both Venus and native contexts, supporting Vulkan via virtio-GPU on
Xen is also impossible.

Direct Access to Differentiated Memory (DAX) also relies on non-pinned
memory.  In the (now rare) case of persistent memory, it is because
the filesystem may need to move data blocks around on disk.  In the
case of virtio-pmem and virtio-fs, it is because page faults on write
operations are used to inform filesystems that they need to write the
data back at some point.  Without these page faults, filesystems will
not write back the data and silent data loss will result.

There are other use-cases for this too.  For instance, virtio-GPU
cross-domain Wayland exposes host shared memory buffers to the guest.
These buffers are mmap()'d file descriptors provided by the Wayland
compositor, and as such are not guaranteed to be anonymous memory.
Using grant tables for such mappings would conflict with the design
of existing virtio-GPU implementations, which assume that GPU VRAM
and shared memory can be handled uniformly.

Additionally, this is needed to support paging guest memory out to the
host's disks.  While this is significantly less efficient than using
an in-guest balloon driver, it has the advantage of not requiring
guest cooperation.  Therefore, it can be useful for situations in
which the performance of a guest is irrelevant, but where saving the
guest isn't appropriate.

## Informing drivers that they must stop using memory: MMU notifiers

Kernel drivers, such as xen_privcmd, in the same domain that has
the GPU (the "host") may map GPU memory buffers.  However, they must
register an *MMU notifier*.  This is a callback that Linux core memory
management code ("MM") uses to tell the driver that it must stop
all accesses to the memory.  Once the memory is no longer accessed,
Linux assumes it can do whatever it wants with this memory:

- The GPU driver can move it from VRAM to system RAM or visa versa,
  move it within VRAM or system RAM, or it temporarily inaccessible
  so that other VRAM can be accessed.
- MM can swap the page out to disk/zram/etc.
- MM can move the page in system RAM to create huge pages.
- MM can write the pages out to their backing files and then free them.
- Anything else in Linux can do whatever it wants with the memory.

Suspending access to memory is not allowed to block indefinitely.
It can sleep, but it must finish in finite time regardless of what
userspace (or other VMs) do.  Otherwise, bad things (which I believe
includes deadlocks) may result.  I believe it can fail temporarily,
but permanent failure is also not allowed.  Once the MMU notifier
has succeeded, userspace or other domains **must not be allowed to
access the memory**.  This would be an exploitable use-after-free
vulnerability.

Due to these requirements, MMU notifier callbacks must not require
cooperation from other guests.  This means that they are not allowed to
wait for memory that has been granted to another guest to no longer
be mapped by that guest.  Therefore, MMU notifiers and the use of
grant tables are inherently incompatible.

## Memory lending: A different approach

Instead, xen_privcmd must use a different hypercall to _lend_ memory to
another domain (the "guest").  When MM triggers the guest MMU notifier,
xen_privcmd _tells_ Xen (via hypercall) to revoke the guest's access
to the memory.  This hypercall _must succeed in bounded time_ even
if the guest is malicious.

Since the other guests are not aware this has happened, they will
continue to access the memory.  This will cause p2m faults, which
trap to Xen.  Xen normally kills the guest in this situation which is
obviously not desired behavior.  Instead, Xen must pause the guest
and inform the host's kernel.  xen_privcmd will have registered a
handler for such events, so it will be informed when this happens.

When xen_privcmd is told that a guest wants to access the revoked
page, it will ask core MM to make the page available.  Once the page
_is_ available, core MM will inform xen_privcmd, which will in turn
provide a page to Xen that will be mapped into the guest's stage 2
translation tables.  This page will generally be different than the
one that was originally lent.

Requesting a new page can fail.  This is usually due to rare errors,
such as a GPU being hot-unplugged or an I/O error faulting pages
from disk.  In these cases, the old content of the page is lost.

When this happens, xen_privcmd can do one of two things:

1. It can provide a page that is filled with zeros.
2. It can tell Xen that it is unable to fulfill the request.

Which choice it makes is under userspace control.  If userspace
chooses the second option, Xen injects a fault into the guest.
It is up to the guest to handle the fault correctly.

## Restrictions on lent memory

Lent memory is still considered to belong to the lending domain.
The borrowing domain can only access it via its p2m.  Hypercalls made
by the borrowing domain act as if the borrowed memory was not present.
This includes, but is not limited to:

- Using pointers to borrowed memory in hypercall arguments.
- Granting borrowed memory to other VMs.
- Any other operation that depends on whether a page is accessible
  by a domain.

Furthermore:

- Borrowed memory isn't mapped into the IOMMU of any PCIe devices
  the guest has attached, because IOTLB faults generally are not
  replayable.

- Foreign mapping hypercalls that reference lent memory will fail.
  Otherwise, the domain making the foreign mapping hypercall could
  continue to access the borrowed memory after the lease had been
  revoked.  This is true even if the domain performing the foreign
  mapping is an all-powerful dom0.  Otherwise, an emulated device
  could access memory whose lease had been revoked.

This also means that live migration of a domain that has borrowed
memory requires cooperation from the lending domain.  For now, it
will be considered out of scope.  Live migration is typically used
with server workloads, and accelerators for server hardware often
support SR-IOV.

## Where will lent memory appear in a guest's address space?

Typically, lent memory will be an emulated PCI BAR.  It may be emulated
by dom0 or an alternate ioreq server.  However, it is not *required*
to be a PCI BAR.

## Privileges required for memory lending

For obvious reasons, the domain lending the memory must be privileged
over the domain borrowing it.  The lending domain does not inherently
need to be privileged over the whole system.  However, supporting
situations where the providing domain is not dom0 will require
extensions to Xen's permission model, except for the case where the
providing domain only serves a single VM.

Memory lending hypercalls are not subject to the restrictions of
XSA-77.  They may safely be delegated to VMs other than dom0.

## Userspace API

To the extent possible, the memory lending API should be similar
to KVM's uAPI.  Ideally, userspace should be able to abstract over
the differences.  Using the API should not require root privileges
or be equivalent to root on the host.  It should only require a file
descriptor that only allows controlling a single domain.

## Future directions: Creating & running Xen VMs without special privileg=
es

With the exception of a single page used for hypercalls, it is
possible for a Xen domain to *only* have borrowed memory.  Such a
domain can be managed by an entirely unprivileged userspace process,
just like it would manage a KVM VM.  Since the "host" in this scenario
only needs privilege over a domain it itself created, it is possible
(once a subset of XSA-77 restrictions are lifted) for this domain
to not actually be dom0.

Even with XSA-77, the domain could still request dom0 to create and
destroy the domain on its behalf.  Qubes OS already allows unprivileged
guests to cause domain creation and destruction, so this does not
introduce any new Xen attack surface.

This could allow unprivileged processes in a domU to create and manage
sub-domUs, just as if the domU had nested virtualization support and
KVM was used.  However, this should provide significantly better
performance than nested virtualization.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
--------------0pKE5AMCA0EH0rScO9pP0tYQ
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFp+A0oBEADffj6anl9/BHhUSxGTICeVl2tob7hPDdhHNgPR4C8xlYt5q49y
B+l2nipdaq+4Gk6FZfqC825TKl7eRpUjMriwle4r3R0ydSIGcy4M6eb0IcxmuPYf
bWpr/si88QKgyGSVZ7GeNW1UnzTdhYHuFlk8dBSmB1fzhEYEk0RcJqg4AKoq6/3/
UorR+FaSuVwT7rqzGrTlscnTDlPWgRzrQ3jssesI7sZLm82E3pJSgaUoCdCOlL7M
MPCJwI8JpPlBedRpe9tfVyfu3euTPLPxwcV3L/cfWPGSL4PofBtB8NUU6QwYiQ9H
zx4xOyn67zW73/G0Q2vPPRst8LBDqlxLjbtx/WLR6h3nBc3eyuZ+q62HS1pJ5EvU
T1vjyJ1ySrqtUXWQ4XlZyoEFUfpJxJoN0A9HCxmHGVckzTRl5FMWo8TCniHynNXs
BtDQbabt7aNEOaAJdE7to0AH3T/Bvwzcp0ZJtBk0EM6YeMLtotUut7h2Bkg1b//r
6bTBswMBXVJ5H44Qf0+eKeUg7whSC9qpYOzzrm7+0r9F5u3qF8ZTx55TJc2g656C
9a1P1MYVysLvkLvS4H+crmxA/i08Tc1h+x9RRvqba4lSzZ6/Tmt60DPM5Sc4R0nS
m9BBff0Nm0bSNRS8InXdO1Aq3362QKX2NOwcL5YaStwODNyZUqF7izjK4QARAQAB
zTxEZW1pIE9iZW5vdXIgKElUTCBFbWFpbCBLZXkpIDxhdGhlbmFAaW52aXNpYmxl
dGhpbmdzbGFiLmNvbT7CwY4EEwEIADgWIQR2h02fEza6IlkHHHGyiLVf/5wiwQUC
X6YJvQIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCyiLVf/5wiwWRhD/0Y
R+YYC5Kduv/2LBgQJIygMsFiRHbR4+tWXuTFqgrxxFSlMktZ6gQrQCWe38WnOXkB
oY6n/5lSJdfnuGd2UagZ/9dkaGMUkqt+5WshLFly4BnP7pSsWReKgMP7etRTwn3S
zk1OwFx2lzY1EnnconPLfPBc6rWG2moA6l0WX+3WNR1B1ndqpl2hPSjT2jUCBWDV
rGOUSX7r5f1WgtBeNYnEXPBCUUM51pFGESmfHIXQrqFDA7nBNiIVFDJTmQzuEqIy
Jl67pKNgooij5mKzRhFKHfjLRAH4mmWZlB9UjDStAfFBAoDFHwd1HL5VQCNQdqEc
/9lZDApqWuCPadZN+pGouqLysesIYsNxUhJ7dtWOWHl0vs7/3qkWmWun/2uOJMQh
ra2u8nA9g91FbOobWqjrDd6x3ZJoGQf4zLqjmn/P514gb697788e573WN/MpQ5XI
Fl7aM2d6/GJiq6LC9T2gSUW4rbPBiqOCeiUx7Kd/sVm41p9TOA7fEG4bYddCfDsN
xaQJH6VRK3NOuBUGeL+iQEVF5Xs6Yp+U+jwvv2M5Lel3EqAYo5xXTx4ls0xaxDCu
fudcAh8CMMqx3fguSb7Mi31WlnZpk0fDuWQVNKyDP7lYpwc4nCCGNKCj622ZSocH
AcQmX28L8pJdLYacv9pU3jPy4fHcQYvmTavTqowGnM08RGVtaSBNYXJpZSBPYmVu
b3VyIChsb3ZlciBvZiBjb2RpbmcpIDxkZW1pb2Jlbm91ckBnbWFpbC5jb20+wsF4
BBMBAgAiBQJafgNKAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCyiLVf
/5wiwYa/EACv8a2+MMou9cSCNoZBQaU+fTmyzft9hUE+0d5W2UY1RY3OsjFIzm9R
/4SVccfsqOYLEo+S0vQMIIIqFEq3FCpXXwPzyimotps05VA8U3Bd7yseojFygOgK
sAMOAee2RCaDDOnoJue01dfZMzzHPO/TVdp3OvnpWipfv5G1Xg96rwbhMLE3tg6N
xwAHa31Bv4/Xq8CJOoIWvx6fcmZQpz01/lSvsYn0KrfEbTKkuUf0vM9JrCTCP2oz
VNN5BYzqaq2M4r+jmSyeXLim922VOWqGkUEQ85BSEemqrRS06IU6NtEMsF8EWt/b
hWjk/9GDKTcnpdJHTrMxTspExBiNrvpI2t+YPU5B/dJJAUxvmhFrbSIbdB8umBZs
I3AMYrEmpAbh5x7jEjoskUC7uN3o9vpg1oCLS2ePDLtAtyBtbHnkA4xGD7ar8mem
xpH9lY/i+sC6CyyIUWcUDnnagKyJP0m9ks0GLsTeOCA0bft2XA6rD6aaCnMUsndT
ctrab42CV5XypjmC4U1rPJ8JQJUh1/3P48/8sMH+3krxpJ06KNWNFaUbaMTGiltZ
7x9DngklSYrX0T+2G4kVXNmjaljwkoLahwLla2gUWwBSyofXdqyhQdwZsp01KXNQ
UCyT/Pg+aDcm/E7OMV3d4lf7g/CSxiX2GSEe6BlhSz+Lmd7ZJ3g32M1ARGVtaSBN
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
EtJuZYM5blWncBOJCoWMnBEcTEo/viU3GgcVRw=3D=3D
=3Dx94R
-----END PGP PUBLIC KEY BLOCK-----

--------------0pKE5AMCA0EH0rScO9pP0tYQ--

--------------F91oUXeotTThnqMOJixIRipF--

--------------8f2sQR9VZFE00mFmOfKmxw87
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmnCnN8ACgkQszaHOrMp
8lP2Yg//bp8wHClzrvsikf9t62My1QfYDh18ub/NOQ3THidAKr/hmi5DTHuKLOAR
EALivpmQPFGkFRBe4ytEhRNORs/nGqtgCoSdGoS623gEO+q2zlsRcx/TWoTmTCd1
zkU7buBjAbI5Xfa3mrFY3boAeJbp1tdDO6lxj+YTpytSB092IW8um0dl5whTHrXW
7XQh03Qlo6QChVjmZx0MZfrS2r/nRf0RZ3c9mSrnKzgNNNKkkYpuyu2BXMX02fcP
AlgNXxSLtyMcg91yPGGy9qFdspO0X69CEdfPmKSuaOF60CHkJAanbs55+EJR16No
4nxANNGSW8A+4NMtRyZoetIkCdaCvzEWLTKbkX19ReI55sAW2uYODqmbYDDdiDSn
HKkpQfN64cShFKi9/J1z34mUeunWLDgP571K6K26ZiwMpy+tfD8de4kFcM3h8eFo
zwrNCR+AhWSjYzNX3ywAuVuLJh/noxnBQ0dZRbRCkp4EPx1mLz1StNOj1E/dD1aI
YiuYS6aU7Hgg4IqOwow/+xPZCj+AxgkRkm7SXrPuNaWwDajtWSp4IInUWJFn3tSr
BF3+ZDVAlqGdz7JlW0GNVaSRVgPWK74P7jIhI1SV+6N46R/bNtSWhl3E7jky6J8I
5aS4pVaS7D1ZGY2zhACc27zL9PaCJW5XuiVlFy3mxC7z0etVAms=
=si8k
-----END PGP SIGNATURE-----

--------------8f2sQR9VZFE00mFmOfKmxw87--

