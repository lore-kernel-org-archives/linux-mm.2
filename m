Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D518606A330
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LctOx679
Received: by kanga.kvack.org (Postfix)
	id 075316B05B0; Sun,  8 Nov 2026 14:00:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027C06B05B1; Sun,  8 Nov 2026 14:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30406B05B2; Sun,  8 Nov 2026 14:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A19E46B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:00:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA475404E8
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:00:00 +0000 (UTC)
X-FDA: 85412866560.10.754F478
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33A03C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LctOx679;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794164398;
	b=felJgkrFP95LQmF0AIAGdWhi0U6SNAcJ+4BWnTq4g2fXGGMHunHnV9x7NtB+DhJC/fI2Ju
	smMUsDdYB1QQYLCmPT31UyrvGxGldt95/emrzesujRjU75NTlHr2mua0FGKHpawYmFGnho
	diS4NPXl8BL9/ngTVxMcNROV/gkl3As=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LctOx679;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794164398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=7gwOv9OHrt/CDRUHC7TNe+xclbGie0CdL0pKKtWGf3sM3PepMDvOMGFgIgPOvhKhIwG41J
	Xy4xPiCPbx7VLUMAT65dJ2dpfWk6M8cLY8DOpTp5iSMGvYfpuRTt4PXPgMebP4BV4tv113
	+asHPJlJscHALrV9snmYwC1BMaLuri0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so1338225e9.3
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 10:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=LctOx679VRuw2tABfhEsGUbkJWczL/ebMMLL2nYum/BPN6J24GlAgVbu8MVmBuH1ig
         E9ySCcfqjhPFyLa4uH8P9osK3Fnc7j/DQeQVT3bgQHGBFxA6jt/iB5XR2OFbjI960Rsu
         0h+RXuCQFEgVrCDoi+9x9nHVU+iOXxcAzn9rAhHEeAYvCy87wVqrGBJjYfQul30mvZOi
         1kGbcEVX15qZ1m18S9OQHMTfnn1E1AfjnLPbuoQASkfenzT0b0dRhAG1nURHuyD5SaYf
         V8T6QLQ5x2qp0hOoIK2kFMMbhGzMB9kzIK1OarX6F8OlAaJHpNMu42XCvh/l/raKLqoz
         oD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=US/uCCuancxxuA75vCatFOMlEbSJoHCQQNnQbZh9OTiwUFenWCu6JoXZtqHo3GuiW5
         rrRHSQ4cVm3ELsZgyQrTyQ6eCrtkLNbn5HGMe1Gj5MEUXWObs5JbqhvaPv4GT+GsupAF
         QkVOBgHapSJixBlGoFJXe8ENnJn6ZkihUkGRJ5pijxRdGJeuNXqS/6y7b6L7vjO1l7Rg
         iIiQfMPclwAvG7uYcr+t+twNCMBZzGKdk2PPYUzrhl6QoViWAyaCvL4AiZpf20b5t0eI
         zyTtvbUuh/ylqOXv7YFzsMZiH9YOpjg3aYp28ZlmqaxsN8mDGuKA/13Kw4tydM5YO1Sr
         INJg==
X-Forwarded-Encrypted: i=1; AL+hErGgr56dfw34HYjlrV2QBtoq6Q5chGrgQC7KLq0773Qjky7IMgiiGxbiP8F/G97B+yvvV0mKcEJLrQ==@kvack.org
X-Gm-Message-State: APuU4Z9W0H5rsa9n2SLEdBb0ga3Uznkd87+NI7e9EbaHSR9Eufx8IIJe
	CWc4lKrqp0CI65Z3HhdPO+SFpSVqeM46ZN7wDFXw4Jue7Z9N6mHOQZw4
X-Gm-Gg: AYBFou0TYT0VnXFVHWcWDV2SxIW0XM7EphZ18u77AZ0+paZFyusX7pR1h6WLf7kBFMR
	RaniP4otlF2gdeufUTC44W/YLWNmHcn57R0WZIkghU9VeGyfyPaaB8RabBAm4z3s2sZnESJAwyI
	GRXZBpcJwWbi+vRuKI7dcOW4YYDlfxbjkwe8K7iLCvyv2U742yIfprHaBN5C3zKnx2/qz98Jh0u
	Go50VHm4o+fEtEUCQLsY9Q6anpui9PWgmOau1gWOVouESZcmQro3YpSTeIHR6WPcGxQ4yshElXX
	tO2SdvaTkA/mfgm7CH9iFRVd3EWZaXmhnv+3PjsIOhNzmqm/Zcma1jBIqhNlKl6rCd9iWuy2hUz
	fI5AWIilPR1n4bV62Wc+nzJkMU4ipaL+3+a1XLICI3S/LlkE5Ew/fx33R+oq0Pc8tNjuGbpC6bi
	thOdYqM9UMAt3odLPlm06XXVkBTfRCAyobMSpJzrLEpY5DqHghwpk+LPCd6izKtkUFP06JrcGXl
	rQnLCL3lTTQtK5Qi/VTYC3Q4BboNAm3RsnX5RXlF+pmC32R88Y6Hr5T/hQDydpezBPbPSD1kKBN
	O69YLu81+hxbifLsvyR4Kmw1Q0VgE+6f/PHCEmBX/sGkpxX67apFY4wzs7dpj7tp
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8dyxbykh9uemgbirzoyrf1jc9aj4fcac
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33A03C0004
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794164398-355311
X-HE-Meta: U2FsdGVkX1+e3sn8E6IjtN8m16eM44KvDGoiI83fbKoytVuDBUyB99C/ImJ7Km0b3PBssyWOlNXjlpNNVpy9plXMdvTvKsBj+93g4gqAE+vcPAJ5IOTfRSy8IpcL+kCbQR0qe8ooddC3piVRTMNBVsSh6Hg0CFqE3WQ78Md4HVSFNd2ApsDHoClodke2YL8eubitrEMxpKN1fLFhLvztd9hGJV/0jXQrmVsTb4WnXvdLK394KzdvgdTDe/1g/WJ+6bI/xFZgiisf7WNhQKQ31Bl+U2Hl7CGFHEb8U8edt3zIKmTlrsPsjZdwEEw13tRRgUC3VPQQw0JVh4iW0s8fPonwqKVEGELZrXlvyfYPbGDjmWAcfWfSQ1zy5Ba6MRyKbsLMXPNGbVET/jR6BJ6MRLe9yNMC/Y3FuNDp5rv9Nq21JgTqz1w55Ca6a5w6z0whxjfwMIiQZR+vXSt6PyYcgx7RL//pvC8t19BWhgdYgq7A3gBt4jjf4jlDlMNP/87YOG2lgkTXArLSBU77dSLQbKTwoi3fHM8VG/sPrxXwUSs0ev858DDLghrvy7GTI8expQ3OJeSDXQRIdMbVW3FWGQshYWWT3UU18Fy4s0HOB3ILbT6DRqg+bac2SqlqQ6pQJ3QXIP631X9gorKCWsaOEDMcZUiUh779fRZhc/eaxFztnKyg0RMLnpY6giv9QrDxJCr4idEesR6Uax335BS6LUBj69HyzwFq0Uql10R2vfaBorgsUuZjVg14CA7El5XxwVZH/FA9r0ZsifycIGqq0aZRDwYCZLEmgyOZ71m+ei5desmnmKLPXL0LhYjuVVzKb3W+VqZyLlyVwnTGKHsC608/ivGJc+66b288DeIUHYpgYquWWbEn4znw6EDjmHGDnbWrmp5CqAqmD4TioX8klPiLRb47QLWYKq8SKGtQQlcvKGxNjDmZOhy6C4uMYfrF1agsXWjaUF3oLBucLte
 cuVaHRLd
 dbDVyX1nTBJkIZ9W3FTKbMnIKdGejvotaSuMrccGySTmTtVvP/A4wih+ayzz5ORVmZpykk2J0s1qaHzQD3FGhBZATkA0GGAAWqrpXTCdl0cdeljKsDKelB9aP/ukGWuS7fyMm/zKhl1m5sfqIYB8dgWDkCzXMrRkkB2A12NE5mqQIA2hrvlfdHJ7fZinFdbLAcYSu4TsZ2TkHFN7ZQ5dCrxKGDpAxUnPUm+kEfypwar9RMzSmLlPDqryBHrjGsF/K2tFx0T8YvEKRwi+N4uHiM1PbssFfUDWzrBAU4vRXqRTUlzky2fCEf2lTCFD7vWay2VXngQtkH3+ILHxXQZtU1fw/Mjf+f92ivBP89zj/uGXlYNMtasmwmDIH7ziI4XfnMPoqdNQt15UPF/rPTDtYi93Kd5Q0olYra87bEgdH6YhI9ZCSyk7pDskgJWJsZ3PU1cI5YgrBa/6dMpdic1BvsHr9KeeHn3WPuFf0b+cYg7jlmndCgX0chnfGSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David

