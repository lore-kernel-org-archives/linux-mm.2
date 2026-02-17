Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA3A7E68152
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264E56B0005; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208FB6B0089; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FA36B008C; Tue, 17 Feb 2026 04:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6A2C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:23:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96B7B1D4C7
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:23:51 +0000 (UTC)
X-FDA: 84453411462.28.F3335B2
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BB6740008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:23:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EB5u2tob;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771320229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
	b=GJ/pzMuHIi6wktm6sE93AEPWmpRHLXkDJ7Ky2ukn3Gx9GegVhyyDXJF4hHEd9saV3p71Dd
	bI9IOKssP8lQbScw8e32vFc6t2Za8DCROc1ZE14n6aNeWlXDJU33du6tsorY/t63Ufx+7t
	pV7+rpBZBgOlnrbzEqMc/MCYWzs+T2E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EB5u2tob;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771320229; a=rsa-sha256;
	cv=pass;
	b=fxdN5bkuDZD4FS8fhN5PksmdspMuHigxFBlOQMHqf3/PSP7uLgq6LbHuGUXD4dFLDt+7AW
	U+zfFidd/E0CnvLGY1Ja3ECoi5K2fMTY7HiHrjdTfmIKOZYSXMmhRiwwU8HF/sQs+kWVLH
	kBSDYyqh0YHUfKDZcDIzT1E/Ja1jEYQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b883787268fso485328566b.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 01:23:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771320228; cv=none;
        d=google.com; s=arc-20240605;
        b=hN90jSQqBAwY+FczJc7woG1LqpTSNN/SUUrZaurPXKR33CgcMaD5CWy9/Ex2JV51Am
         hZ5IIUTrXI90CRC9lQynnF3oRzIge6p4mVP22IjF09V/OCiyi1nVBn94jDT6/thS+rxd
         iTEDSZxEoEzFBBnb4sl7Pqvy8tsV0CpvDHEPXCAMvkgj0zVBLUAjkLPrUM/aW9lL8qN9
         FbTPXO5bqA1nVPYiD/CTet5vaisSv0gVPFae5z6M7EmXRsgK2NWCX44UB/zADHki43Uc
         ZehgJS/VMfKb76GFZNnwDd8ULWPqJVNslVwqjQQ9czAKvKn2PJX4sZqMEAiQzODxQB2J
         7yyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        fh=1PlsE218GfScyZuGsdGNbu/KkIJdMWRbFkcAMlaKfSA=;
        b=iUJYAouYrTr8vfrLWeJcEDpWUA9Ul55Bf148xDSRiaiHplCsdNzZEZLSqi5R4hB6fq
         Un9AbYMdHINbO0cUIiwrQHdgpo1zi7ENQx6mGxtrb89B/O0Tc6GljyQsBbrrTUCE2mMS
         YUudekY6pEfDMhIAD+lhXej2uXZ25ygT4Q8lQ/OgX64k3QNhHnwEjL19IIqeyxJh6Mq/
         t3z1bbT5PNkFD1ID4TSklJbaS4uFCx2nZXOERSp2bUUCxigORHQqq/trjplqxEh8izZM
         7kfqm3XCaHU4XOK7QPNLlsIP1FhUWhD6O7tDD30C9WYW1f0CYaYxe1YDwrNW8SD/Q5N6
         /dXQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771320228; x=1771925028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        b=EB5u2tob3dXaqu9QmvurDPtK4K0FIoHasIxDi18qqWH79kqbIghdc89OQ0/Z8Ap82q
         7e3L8tbbV29DjwF9sf3X2sIhAJWd7G4EkQP3c1klxowfRqWIIdRTKas20somHQmnOnta
         oaTPUa+Y+A1p9v/fAhTQ8YGNtvX0fogpDKOhwxa9Zcg1yMes48vOI8ifSDV7XWfCT2rl
         ce0ldEZIc6pnM7HsJWM+AKoR7t2whKdVadAkO3ZMhXy3WbMVMVzn4tMu8oAFdsLLv+9G
         mgsS/mzeztLhhehX4V3EN9KNeUANojQzOfsfmFe4lbhbD9hjZeX0se/5hr8XmO0hzLvy
         knwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771320228; x=1771925028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y1CU8SyBn1xLiMljauNRp4/xP/fPOy3c++Qg9ZktGhw=;
        b=uQrhxYDb7d3r5Onx00LQKdhE9W89ZM/0hmG8eLoO0VOZdQsUmerdKrjBGf4r/GH+G/
         3Fl9SKIGrFrkOum7hdOoytIcGad1vjMzBzfxDG/jqCkV3yub3eU/d9EX8UtTKpD2mKX4
         9qiyfN2TRvr/AjEv5dYMbzZIle3CdceEJ2yD2VSM87lAeYDr/YmQ/upK3kFkQ7v2+mkf
         gnMV+fJvum24C+Gc8UFsWUBFMwh3KPY0XMSkvhWN7gvLFtLzRlzwsGYrAICkVOU+KlTF
         m/XF99UnMl0Uzg6Gq2+l8tK/8DoDNTCgCGmSOF1N6iYq+W8WzGzs0+gNpn0oiWsG2XXo
         IXcQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGl6XChM5oGbiZ9O3fpKfcP0NXYfbDg7Pv++ADVlHOYQS89WSnWBsM0BtP+bstNUaFX4Pah8mMvQ==@kvack.org
X-Gm-Message-State: AOJu0YyfRZ999HfqI/Y7R4f6F0tvQczNLBbs84KTxdSKyg3VZzI4/1d0
	+KRFI1q5QEGKuDzzv7Qc29SvvRvBA1i4Hc1b0lxHuWpBPpFjZo0agtMyyWgaYjji02Zkto6RtIo
	S4QWzWEnEqFxSpgX6YEFRxE/b5AEFUt8=
X-Gm-Gg: AZuq6aI4ZGxp3/JPMpYQAYSnYlMT3E1mcGcsNOjt3t2IXKKP+GssZzxEGWQq7S3l1rK
	OgOoFE0gpSFck6MNWAeXMVAjeLkSnJdopVG2XXVTg8gZi8I34ZIxujLG1aMsupWm8jd6VOy8t9u
	a9TI7aBz+8sY58tEynmyK8o02nv/+y3+BW9Uf5z695o5T82EglYWg6MynmlJNrvd4qyMQrRhq+v
	gTZQ9ARyEsHwFDo1KelUTBQ9TUoqYQno5S7Lya9WRtZG6zObNuNQceIkKgR2frpjQuOgES+BEEC
	sO4stSTA
X-Received: by 2002:a17:907:e101:b0:b8f:e438:75ba with SMTP id
 a640c23a62f3a-b8fe4388da9mr248776166b.29.1771320227576; Tue, 17 Feb 2026
 01:23:47 -0800 (PST)
MIME-Version: 1.0
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <20260217055103.GA6174@lst.de>
In-Reply-To: <20260217055103.GA6174@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 17 Feb 2026 10:23:36 +0100
X-Gm-Features: AaiRm52xz8EBc9OEZec10DoizsQ3eTTptMfYZb6-P8BJzMypru0h1TRDSfoM_ik
Message-ID: <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
To: Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	Andres Freund <andres@anarazel.de>, djwong@kernel.org, john.g.garry@oracle.com, 
	willy@infradead.org, ritesh.list@gmail.com, jack@suse.cz, 
	ojaswin@linux.ibm.com, Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com, 
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com, tytso@mit.edu, 
	p.raghav@samsung.com, vi.shah@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BB6740008
X-Rspamd-Server: rspam07
X-Stat-Signature: kefzmu77339mn7sf33uhwdkzbpyngs14
X-HE-Tag: 1771320229-862206
X-HE-Meta: U2FsdGVkX19oqzk04092ugJUp9/wRqHuSRGVleIjYQIcDvhNTbnvannCmKp+ZMx0JwSFusYd3B31PnPIHGfZxSdtzU7tbF2Ao9jJt2148z4h4TlDPeOFGW4YFuBLAav26+I05CnC0DvXPF+VTZWpQC6zMxu5ChuZejMrjJWMA2YQw8jhLouIk4ty0+ZOfoSg1+cA7NNjYflc/kioYqDb5izjWiRu7Cw1Zs1MOl6VohB8+dRh+ykAPX8Uo9h0jj/8q86RXYrqeui0gXCyfsVYygsVTwyXT9SlZAT/SOS2gk514QHnLBy8bXK1VL+clUR87UCx0wWCPzKZ/4R74yJt22KaM85UzNtERrOWGpCtrBJuAdRq5kp/sEKDHMMvenuEqDMNvko3rwe6GI1+v95DwZnp/eOo0j4kXPSNeQxEQM+hzX6zqMZ+y9VoF0tzray74uBmaekgEgq/SpWDrJfUe4jLAUOJ4LkGvhJXIJ9fzctGgfjiAYfXP0ZWuLnWxKWUWQxMfFzzXjP+ssUMLmv6Mn1gVQOmPcxvXHZUI3VSKr6uwQSSJRe49/MoXhvUXk3uvuRvQZMlbQXkMVkhmABPU5nHOeLeVCNymcZ2sjrqNmJieWRqggibMmLkDuQe1QUBuLYFljnz20RrXKStm2GDmkYbBolnBZjrwgyG1sQbvW3e2WnjZB8jD/SEj7xzlqONq6ruUqBhlvuvV/OGnaEPqjKqaWi7LlZjSeho6O9Lgfk9tLmqu8pm/nvwogZodWDUb7BMSP8AykbxMdRlCbvWxNM0yNsRf/X+Hm4tazyqL6Rwfj3kVxc2iqsR3PdFIDusDnePuck4iMFIOQfFMWV00bu4hN6sPTmSozpmpPFNX14fNK7dHXGd5eRVaDPWrl42stzc38sG79pP7bUNymwURZyYSb8VuhXcNevPeD9DxjXs8bWKaLlFDYcErBV9asFlv0afCg+BKgBm27KzXYm
 u0Tp1oN0
 snlMLfQ6r/I/4Ek8sbVEq2odOsGLFCsSdszECaMzxghM0QM9sFbtEbghzbT+HpOAxeKH5hKxWzbbhwT6jP5dOcdOAI+fQkelBFINOPAViAxUyp7b72AcMkD3qwfd8UFs3D0pPhgDOSdsDDWCEOxAZA7KF2DU8thrtYfD45ABjkMeivVZxDGb2ImfLMA1VrcmdWAo+Sm7vSN/a3ndm8ig+ZCjv6BSJ/xwUEm+QLLi13Tmfhi5+1NzCJrZBK0u+vgnfYrhZEeV9rlZm/JbiofL2x3/HeXTi3X7DLnvrESn9WpHgahKZwoewMuoPjbeWwVF9NdUFVDpgQUbXJdE5Eac9FNw3qKZax3eKi7R/kgx8Y3m5EDQts8ChGz4BjSRfZBDyqNZn1/gS0flbigpEg86gBsu9OostMJjiZExYocwUpKXmJ3bWjx5SuM1DtnXoSMGVoormt778AngTIle+v2beoL7fsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 8:00=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> I think a better session would be how we can help postgres to move
> off buffered I/O instead of adding more special cases for them.

Respectfully, I disagree that DIO is the only possible solution.
Direct I/O is a legit solution for databases and so is buffered I/O
each with their own caveats.

Specifically, when two subsystems (kernel vfs and db) each require a huge
amount of cache memory for best performance, setting them up to play nicely
together to utilize system memory in an optimal way is a huge pain.

Thanks,
Amir.

