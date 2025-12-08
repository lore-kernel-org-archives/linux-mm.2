Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EAAD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 16:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51DC6B0005; Mon,  8 Dec 2025 11:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02056B0007; Mon,  8 Dec 2025 11:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F7D6B0008; Mon,  8 Dec 2025 11:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2B386B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:48:53 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43BDB138094
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:48:53 +0000 (UTC)
X-FDA: 84196888146.29.8239521
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 06B54C0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:48:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZTgF84OE;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765212531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGTtmc49qGm8JmqTcihsC/mRcolGTztLq1MYlXidkeo=;
	b=O/WbSEcevoEb2PP6Ce7dwOOhfSoOWxyIuEIQJTUg0zjPYF3ioNF2nNyBW6LZNBnAZHTXIS
	GMSwo83p9SG0+NfoPZFdEOU0rxppnnnXlOyvRK7rtjmDOa6FC/HytGAycF9GKIlW8mqeNf
	ebUiD6A8mBkRf9nNdCgvuZd0VnWToZc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZTgF84OE;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765212531; a=rsa-sha256;
	cv=none;
	b=PTKVvhsgXsJnw2uCl3qGVfDXIzTCpacTWFqpmN9JGrHX1g042zQnzExKzzO/EYyhxRBld3
	gta0Uuoo+/Etn0iUtcC9PfVhxtGoSXB7K50y+mhKmqNXQkKlfuuNNnLjoduiDu0xgnUcLN
	k6TC7e6cbt0hrytelZMTXnTo4Fe8WDY=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so43955645e9.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 08:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765212529; x=1765817329; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGTtmc49qGm8JmqTcihsC/mRcolGTztLq1MYlXidkeo=;
        b=ZTgF84OEw3lBfyyJ7tf5kSBooOb4OWpzdDCGBbf8gGCyjOvWWMKCK+obry7X0WtRVs
         EhIAPx8WjmhqgzJ7qD14HxsdO+wgrbR30C+7iBzI7mWzV1SWcYxmi03dEafUcQn/GEfe
         +UxGYJ2GN9lW3HOjh7muwLHn3AApgFzHoB/W95ucmxgwnaW/G/Ai1bewczXl3Nh+UCtV
         KzMR7X82ITdJmqxczfWwkhaFHwPTY0HXlxKJlGGzg2pK/rJobOJu7Uwus3/P2Tl6fnrr
         14y+7jZi6wGnNWyTMYPH+eAIYZ03Gm5qVs8pOHOQH60rC+Wjn02jQtLI06PK5IakEUoN
         x1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765212529; x=1765817329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NGTtmc49qGm8JmqTcihsC/mRcolGTztLq1MYlXidkeo=;
        b=jfFZlfxBnwXxIoNd28u/69dS9oGmkVHzaAyGVk/xPZcTzDnrqW77SitRddFSd802G5
         pbDenxtRlFPrTMJ1j5wmT8h0GkpfaeaZEU5xN4bNRjDjCfQoT+H0sNh1I4eBejCis7x9
         sbcW1rnr4hUcPQgBHEJEFjVQPhpVxXp97drPz014BzfJPN0BxExECEGZq6h29pv2SMr4
         lSaEFUj/PRA6I+LiK6o1v9JLBCN9NZRMsE7JCus2k8t8gZ5T0j8gcILFpCpnPBAQd6i9
         AzzngsqxKGYAU4xiyBotBjDJIvxIQhN3RUyoDMU531lo4BC/bo3QaUehvc40ny36iod8
         kDFA==
X-Forwarded-Encrypted: i=1; AJvYcCWKfBoqi+4LWsBe8mVFbFuuuSQx2RsqByIuQdRuIsRSdiA2ikIJ/IG4MhgwwSrMdxEv2gBhfGHpYw==@kvack.org
X-Gm-Message-State: AOJu0YwSMIIx5E3fioEEtYSPAtJRWZdrm8jHstOA2ZnCEpKx43UshgzQ
	nfwwVj0UAo1lHI2KLA6UZ/S8zFwt9+GxX/cgdOyCLHqt/bg6IYqQuOkopDKqkIAkt6Q=
X-Gm-Gg: ASbGncsRrsFxb2bQGOLP7hRj9RHJ4gXtliY0LbEMk2HRnsiWronaCCvLd2B3QrvTc51
	CXh/7V4emFCPfLkVoCzkO4yEnjLLQ5DkVa3ROZEdzCZQ1HZpZMd/C+38TF8TR+8fpsibGBJqfLT
	dwTkFnm+CL8d6h2BqcVBLzAtsn4V8/7CZdqveUcL5yjCo24hpK3YgOnTXDj7ZhjpD9hijtq+XSn
	8udn64VLcDiKKKr6ryNvVWMT3dP3ZHXRbg3CEAD3P76e/38YFLx8BNm/xujPBgzz5boArKIe3AG
	NFLJ1p+kC6kXMGz0N/ljWMxw+vpbVLMNyUC8m2bFuNoZYQAXP3+hSaZUMSxfiTHohV0MuoCAdsY
	abWvUxgnhg0q8KfcpHi9VFfXoWybPmRSXw5uFV4x7PyoCr+/ECdxk/yds/KvuTfz/IZXjNpYSvA
	9yGOmO9O7uZItpGdzT/+d/Fh7m66NgMsInAhGLpm8Kzw==
X-Google-Smtp-Source: AGHT+IEsJ/iSaDvwNh18lu2wFHnkomxJ8Hvg1XZtgMMg6hpjOz1LIBWnTk3op1li+CYOfSPEkMphCw==
X-Received: by 2002:a05:600c:1552:b0:477:73cc:82c2 with SMTP id 5b1f17b1804b1-47939dfbb50mr84510895e9.9.1765212529294;
        Mon, 08 Dec 2025 08:48:49 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d331e62sm26750068f8f.35.2025.12.08.08.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 08:48:48 -0800 (PST)
Date: Mon, 8 Dec 2025 17:48:47 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Chen Ridong <chenridong@huaweicloud.com>, 
	Andrei Vagin <avagin@google.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	criu@lists.linux.dev, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Vipin Sharma <vipinsh@google.com>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
Message-ID: <6dmgfe5vbbuqw7ycsm4l2ecpv4eppdsau4t22kitjcjglg2gna@dyjlwhfhviif>
References: <20251205005841.3942668-1-avagin@google.com>
 <57a7d8c3-a911-4729-bc39-ba3a1d810990@huaweicloud.com>
 <CANaxB-x5qVv_yYR7aYYdrd26uFRk=Zsd243+TeBWMn47wi++eA@mail.gmail.com>
 <bc10cdcb-840f-400e-85b8-3e8ae904f763@huaweicloud.com>
 <CANaxB-yOfS1KPZaZJ_4WG8XeZnB9M_shtWOOONTXQ2CW4mqsSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qhatuyfusoefghqk"
Content-Disposition: inline
In-Reply-To: <CANaxB-yOfS1KPZaZJ_4WG8XeZnB9M_shtWOOONTXQ2CW4mqsSA@mail.gmail.com>
X-Stat-Signature: 11bzuak8rxrc46qayrpu5ohawxj6h478
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06B54C0005
X-HE-Tag: 1765212530-573625
X-HE-Meta: U2FsdGVkX1/bfHOii01orYT4DXCmAY0j6PVNDZT7LIC9InYo+TvNWlMVtQbPen+67h3cfdiJP0UbDp/p3EwPj+Lnu/x7Cb+BBW7EHIBgx5dQlIb3WbcBr9YGNcS8VJiqBndAULREb2DukGuKaPj9Nlz05IK7C3C8+D/ctTX3Z3++NqFkNsCX6xm6bTRAw2InyECZ0aqiZ5hkfBwrqraIKQrB2xiTEiPcaCrO6j+4oJqi+Ctavv4H8Vh+37Gc3g1QE5SVkLi8XBrqNmyDi4bF1CrTovVxMHWCSeEuY7haqeAMucv9FWM0HcHo+ZYsMtI4eQdQBw/hMPgOWyerON1lCBeKtd51nFqkqEGdNjn07T6hQfcBRks/wqWLik/7T2oR+fVtDGYRrCa2kulqEYv7ZDxCu4ixOM9ejA+fqliWlpr1BEyyZYblPPpsy0uRJL5brE3dO4Zty55wN0NDn9In7+u89yp4+a9WJEANdOEiYa9awrFQWeo023S1zmhF+1TRsmyLoUg5edT8R2TmAippeB2OJlBzk5myGMiXkz8HC3EZ+FedIMBDtBgunjiGuAV2vu82oXwxS57kYL3i2izfZ0QjtoAQtaVYYoC5MxpeK05TzTniP2XPYMz721zCiSLMJHVtTKZ8azwQgQb37YiyH82LoFt5Nxc4QWgyPoEZ6CuUuEUZdY7DZMIYWx7zB5W0P05ctewucDf1B1blrrTXeY9EFrOGPZwmje1dvice76kHxhqZ/jPsLAk1z/5THDug/ltoUelBrTsMC5+IlPqGyzNj8enx+gI12mTr5ayca6jMSgQ00hyy7cTeR4MhLnCsCgBoGt5McqOZeMKXL0ofFVCJAswVkheAme5ZvWkpwOeriKe2r/opM4wXi/nqXfxW1GOTzVRPEOMM4nrQA7CIIgIdOqpJWll+SYgUN4xRwKYb+ifZH3HhdIOelH/TVD2I/y1Pc6D3xYWlh2nrgP5
 9lRTrLHa
 rHEnx1nO5zZbRKdSV1CejhtBVhLjKsRXiTNnJPig7NzpfF7tNk8fV5U2QOBZqpzCh9qWJCksM23GC+Vui/fj4PCPNwYA2xAetAcI6fw/Y0ZbCSu0RTZRC8KhqQ4WQaTNr5Kcf4knpse4p3OiMXGDeKpsjW4DK3Dr4w5wr7LPOiupaJ0tt3KHMC/JVWun5gQNnIx116HDgjOt1GG/W2mparSKY0ShyVpJMO2n4gJcgD9X5kALUW1RfinkuL8uogZKOFkYo/t7Sje3dqSkMPp+ocIQTdWSq8sF+E2TRmmEMigHlve/oHb2S5cErLw33chfMN53vazlc0x/T48Z7mjSmpkftt2W10iyDzIlSu3GjPhMsclL+fLuXspN4+8hYXFjTSmsh/yenubPVEWsUXiDnjqN3OrKhoAJiW8ZphQx7nAfIylyo50XDKbmIgHY3wrZL9qTdZzGGiy+Rz5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qhatuyfusoefghqk
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 0/3] cgroup/misc: Add hwcap masks to the misc controller
MIME-Version: 1.0

Hello Andrei.

On Fri, Dec 05, 2025 at 12:19:04PM -0800, Andrei Vagin <avagin@gmail.com> wrote:
> If we are talking about C/R use cases, it should be configured when
> container is started. It can be adjusted dynamically, but all changes
> will affect only new processes. The auxiliary vectors are set on execve.

The questions by Ridong are getting at the reasons why cgroup API
doesn't sound like a good match for these values.
I understand it's tempting to implement this by simply copying some
masks from the enclosing cgroup but since there's little to be done upon
(dynamic) change or a process migration it's overkill.

So I'd look at how other [1] adjustments between fork-exec are done and
fit it with them. I guess prctl would be an option as a substitute for
non-existent setauxval().

Thanks,
Michal

[1] Yes, I admit cgroup migration is among them too. Another one is
setns(2) which is IMO a closer concept for this modified view of HW, I'm
not sure whether hardware namespaces had been brought up (and rejected)
in the past.


--qhatuyfusoefghqk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTcBbBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ai8MAEAyeSN6KCarnIABEa5QMqm
oISbZ1p14CvmHATzKA1bOyEBALyv5+on7iSaLxmoTq8ygkMxgB3VKwZP81DcFFDB
DEQF
=v5da
-----END PGP SIGNATURE-----

--qhatuyfusoefghqk--

