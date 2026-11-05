Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D995E606A339
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE42F6B05B2; Thu,  5 Nov 2026 04:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC3B6B05B3; Thu,  5 Nov 2026 04:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1EB6B05B5; Thu,  5 Nov 2026 04:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC3A36B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:54:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A5C7140971
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:54:56 +0000 (UTC)
X-FDA: 85400606592.08.1D6E000
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 76790180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:54:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=m1q9k8imljrB5eiaRF/nV7hnWBXeK9WdF4dE6wlhY3rzcxmcUmjwhVRu3dDAYPkuVxwjIv
	j55eULuQjDWnd9Yr5ZlytKAvNu+kgrT2q9dUWDksNHBGKpupqIv4Nd+ZkTdabX998jEVl0
	4NZ3KWopcXd2hL+qHbaO+y7lz9ZjAr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872494;
	b=XjjRr71Y1vzaJpj1vhsjVjrE7z/1AKFVwH2yQsJkrDquX5Dknkp7VwhMxDGxgO0WpNd9/Y
	qRSZTxSzi3In0JP4lpid6XeoWrem+M0ju4IutmMx9sQ5taiYUXG7BxT/3KxDy8QnqeKhuJ
	RKz0PULQD6pJ53MGncL6qOq2d17RfSk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eae1276409so540520e0c.3
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:54:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872493; x=1794477293;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=FwuwhPgQ58HOxVc3EaPMUKNkjsk+KwyronrnHocWZwSKCwiTEkKGeRdEmIWlfqlMtq
         IzgBhx+JW92WDbdY/RB6DTDdiygUVVMGdlsKFkn+eoohXJFzYhQEoT6c+OddOpSN8T8C
         VD7gRJmKRhmqd6o2mOhCnb3M3QZcYE/VwlsUNHU0mbrnRFewUqP+L22BRMtk/kdSRvHz
         uIFXfWg+egufl8G+vLFnywnccSktn3c0Fomg7167qubCafzsm8TpS8meJXuUNrpdYBdM
         2DftaWd1qoC0q7cqjFwHDqAQojFteXQNi9eIyKkfJSVSXvXebAKWMzjRaqkRUxgpxD9O
         BBMA==
X-Forwarded-Encrypted: i=1; AKwUvBxVJLUQkim9rDmqkB9S7DQfJdxXkMux0TYY2FcMII8NyfQKpHi1Z6HbM285ezjL5SAgsM8qpYOY7g==@kvack.org
X-Gm-Message-State: APuU4Z+b4Fj5VGmo05CGi5R27/miftTrGtT6x4jA7lPPfRk/LjQSXBlK
	YebW2qWXVVGW2TXgKnawaZEbFWaoZNqkq6icshGuJ+wXfpjqvD9t/Dzf99pmQft3TSI=
X-Gm-Gg: AYBFou3qf6HJuGDmNlkCSyew0O1I/6+AWYrXlfK6lnXJxV73lFCChdQXQCRX3W3Ncr7
	FD87o+u1AiIViRGf7LdxXQm8gSEDJJXPKm/Tt/2zZX9eXmsniS5nH12iwKj8CaayNqBZSPuCcwQ
	YHZ5UNYk37KxqlYM7UVdeypjoRW9xE5DEDPXuSCRpuT8aaXcopyJe2NO7tnduTXTFsqsmBNg/6Q
	n/JkLMN/uvbTQjkuBXCSuyzYQ9Hb5gMYdTczB3PQza740d/eE0aO0pk2GLbqA4W5mLrJebwbBJK
	Q19/7o9fIgDZpHX7OTP2ZXDsQEmLZ7A0d+KNi5QRP8eCBJv+ESt4xdtsXLzgeAxSWvMOmBh+aT2
	l/MS3nyGg9ErthWgxVMIsdUFZh1s9qzbdRU9wHvyYuQ7XJszaumNldz3hReFry4Z5/ZFBdjgUUi
	CYftZwV1XVLlTdgB0eBhg/z6oGygXEkEPdFqH4JASZUH1UQ2/Yd5kL9m2u8Ul6+1zNecv87I2Vo
	mDazZTOlZNwGyD0a4cWmR7s3KHM1tq9Z+mc7MJ0CrSCvTbxBXLHnvqgO4mQPWetmh7hzf3l8wUs
	/Ik2gM1FIWmVhTnCi4sidNcPDmiT2PtrfGCSlQF5hjtcwFPvZKEccXJGWIyZAkPEiU106w==
X-Received: by 2002:a05:6102:508e:b0:7b2:508e:3d57 with SMTP id ada2fe7eead31-7d0727b109amr6787823137.4.1793872493540;
        Thu, 05 Nov 2026 01:54:53 -0800 (PST)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d8afc268sm4158988241.4.2026.11.05.01.54.52
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:54:53 -0800 (PST)
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eafb65e204so526248e0c.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 01:54:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzA9YLO/E3KAMuEiDrmFpipJIn1INlt8PE7rtXpwts4fsFLczfzHDiN+6k5L8NGINN9FHmF1Zt7dA==@kvack.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: o4uwweanjxr11fciq6j3gshce7d6qt8c
X-Rspamd-Queue-Id: 76790180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793872494-383200
X-HE-Meta: U2FsdGVkX1+SzcZTZbqy0n3UxcZahXu+8JnkizwO0wyXa57V5iDLbsceMWEVPLZCizVwmSxzc889lxntzybngJC92Lq/xFz5vAr6RhcbjKT2Ysy0ikWf4WIfBhZ0JxLpkm1XP+p+j7Ep+eyuRbp1afvfka6tkzCapFi6Tp4kDFaRI2al4R5kZ9p8g3h+eGnfNft6dM3upRTi5ZpVdkr+fkafafK+Sgczc6BhOZhq9XP2SVd2zfdUpJ5RD05hAzSERvAgWBuLoLnANwretW/Od9+z5fR/U4d9kfdmglpS5QDHXtkPXpa/4QEtQlPB4afT03VoAb89Ve263u4hJ9lqk6QxWQPh0CMeS+39eb/ftH8gfZKepHcmoyUpjncDWPcmoKEi8TJT7A6tEpasV2w5Fx0vZCoiixB28QXQcFWR36rIkoJx2wOdosdh1K9Z0UOtTw0Ag2NffsDSAE/oa6miJFHKbSxcE+SltgdRSgeziVMma2z2qR7CU1o9dpSVDlN/CQdp1d9iH/NLU5EVZ+BQ9ZS/odgHLwTa3vglmhDp4wfLhSMCM/QvE2xd5A/M6UI3aHomkQajottd48hZGrJ8En7Kclq5vkO8oM7HYY0Nr3T99RL3llgircaMAGIMRidUlUKc744IJDhlLAkSLlyV3urzJsmnl3hyZ8MrToWSrAOB0ChALLYqLXUHI2KNP7xhmMrImJOZx7XqwjsJZtVsz6NukWhxJv4G6lsB758vsoPUTkFmWexCHdgm7RcDQuuWn5K1YkvYfUwj2QsCUhErVKD8TsSUTv8boG+9/753eKEjQBzg8AlXQmfFyPLmYDkH2J5r0oLcVmvNL0FX7YW4vh6d2mxYuerp9tsM2XzIhI+AaBoYFkYiUh/S+ZBUbgg7LidAUOHvb7zcoex3Ij4MQTb8cbefEJTYxb2S/3JDDS4f71bY5+SLBMCpF12UDGWrJt3uNF0czTw/qWmolW0
 /UX5FnI+
 +Y5s6Fow/ZyL+ZTlOTFiKXkw57AF1oBbIcHj/LadJDTOaRcRy9LUlsRdOYNg7P+TFf9tePWcwmfmrqX2JFrYmBzVvwbOcA7Bw/9sAcDjrqUiX9XjmvowFHfDbdUf4x5mrMX+X18YuarIVojAcS0fk8kq4L1QXrCUUIF79nYde9YxI6jAYZzu5zT44G9JRHhWJwHDOBgCAdAFh2gaUlxX0nDpbgWf/0RUaOi7M3g74iTIq4+VF6nZZNOCd++ZzlbNzmySeI97Krmam/PhHL4iJh5QybeCJo8qlbLUwO5AdsEDb/YE6BGzeSvGdlJoa66b13gLF0B9lu8g7xnDBgIjClMB6X7ld/3ydDykjSTjIJfJxn8FxT5rl/aTgQApDm6Rr4P2sld0+hAtZ8EyeCZsVGY5BvCMyteVmWqqbQWIrevaABxK2DtyRx29o+gU6K2r5gDjuBroHVYqvhudPf6MDP8JhIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

