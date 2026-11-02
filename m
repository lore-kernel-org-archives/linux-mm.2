Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51428606A92D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 18:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=WyKhbaEO
Received: by kanga.kvack.org (Postfix)
	id BC1D76B00EF; Mon,  2 Nov 2026 13:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B256B05B1; Mon,  2 Nov 2026 13:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12006B05B2; Mon,  2 Nov 2026 13:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7277F6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:05:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC45AA01CE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:05:54 +0000 (UTC)
X-FDA: 85390957428.07.199B2AF
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id B40E34000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:05:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WyKhbaEO;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793642752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=PJfBlnoSvAnqoS3JufhY0eZaKnZNZr9idXWBkB0xJGS0xx000vwaN+9HDGXXV3x6fgYf5l
	G1Sxnv9Ygpko2AIOf/9OFVy2aWzNqyvCIdRh85f3M/RL3fbpduPSJ7+1VvNsV8OYI6tDHF
	ULSqxIU6MehbU4pW6AADfbrbJDQbtbI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=WyKhbaEO;
	spf=pass (imf17.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.47 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793642752;
	b=Cewp9/o1GVJwydXgJg4rWH+A1fs4Kyyk3pNsAJB9HQdcBt4ldeGgw0bIur5lnRX2AUbkmn
	OFhN9UF6yp3rFIMvoJ/4qpJ8yE9jxx5kqOgsMMQPDJX0lD1XFukoPGszJ6GvXE6mGke3Oh
	LK2zXG51LRRkVYxKxe/kjDw5zN/HoYA=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3801937e87.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 10:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642751; x=1794247551; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=WyKhbaEOz8ve03eYKn+AIsIfjS3BWGT5b2wQZ2v7UMDLkNPkJv5u5uk8Jeg0p/KUYV
         M+fT3+fB+CsCkMBDPPFqKx0f72udMGM4U7/sy1jPNYzZZyuYb/TK8bufZojhVW769X3f
         oEsR6M+sTmyVCDWP3GAdodW1oMi2tSteXvpcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642751; x=1794247551;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=j3Og3WyOq0ywtqzD4qHDVi0k1A2Y4zCZOIVvWcffYPTBNd4UiXEn5PhtVSHiuhAR0S
         n0pL1nWnRE3B9/O1E/Uvb53+52hcXy/54c4jUdxwtYCb0iXnG4zCQYhPQevtn9RbhaJg
         Qmijbda+u+TCXLQgMoA7iqVBi5FsJQo9fOwybsOVtfq7DG7BhuCMIUHRpDbvPF9UylQe
         VO4p7Dd5HkQjhXSLnmSuMBjc7EeFNwgWuWj/4sNKAOgZeQggClCjTnyzRppkfV5c6o7h
         4oDhFJKseGzw43B6QNmyg4Vq53oOaQKcGm3o2mYzSQMMqShu1wwGyExpnk3R1FHFd7VE
         1fDQ==
X-Forwarded-Encrypted: i=1; AKwUvByVAxCIOA6TTFRY6o4Frhzg82mUrf0NXYwTWt8P+QZwGxvq71NIvVRXnj9Y1AZGOrzYRyKxM5lIiA==@kvack.org
X-Gm-Message-State: APuU4Z/MR7h0hxIlLHcwZef1nH4qEiZlAPZz2IKrqQsDI2kB8O8836CN
	mW2vxlJ9riaC45urRnPli5IYxdtfz3+yICljBJ5ZcRoU6HYbUi2nfvsAkw94dpvDU+exJmslXHs
	IOfyOSJjY+g==
X-Gm-Gg: AYBFou35x225BLaf7NRnwo0z/gjTnVALUuKDfKCGx2g3lDBmxVD7/BfMNIjn2t9yfIC
	hnjyHz5Rs73xZfYpvtS+UJSt2hiRvXJkOfAk0DLgOtAHOunc+sZAYonIzoPT/FaP5POvg5bNbyn
	px5FIwCybOAFfB4+ntyzYndSq380K3wHs0Bd5KnRgyVseo3ir1A5dzflv6DLnHw28WN8+HUGojx
	cRM+xYKt5/icETm0Ns8u8h470aELjLjFjpOPtQ8Lowa1Kcrcx6SVMheRH58uBKtWyJ7c/LIjoq7
	MDArNokcEBsjNeXf/pEP924p0VAOYzB5Z/25dV9jQeo41+qxnUcMvw46SWrd0OcH9IgdtNDpH62
	OjWjs9owa084IXIPp0GdGyCA6EUEb/fsLNfQFp5IuTGFYtoaEyvFsVyIi+X1cJXZ7JL5Rha3XAd
	jyq4k1o21tpjA8b9fldH3D6xUJzc5e+fSA2fmQ0m9ONsiCG81k3CynY2PD2NakNt5z6Z3MWbcp0
	iO+nBwqEvTUnA4Wg/DRhGxhT/9E9ma/Kuc+fVqNNcPc79B8YTwn/2lcMrG/51oPSOCakkLXGcK+
	pK3MRzKfCgqu0gcITtXmJmAf6viQEtct2a6ZXcua7WVbuwr8XzQ9tUsSlsmRmcjmty+bIAnBXUJ
	QQQ==
X-Received: by 2002:a05:6512:620b:b0:5bf:d9c1:58d9 with SMTP id 2adb3069b0e04-5bfd9c15916mr2636272e87.23.1793642750721;
        Mon, 02 Nov 2026 10:05:50 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe9856894sm759225e87.5.2026.11.02.10.05.50
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:05:50 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5be4fea434bso3801932e87.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 10:05:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxlPgz9bvuRqZ5eAUSqSIdenqSNNHlK3N3Yi+doMIF8KMdWMS+zs2E9D15k+RvsuSv/bAvynHxz3w==@kvack.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: p1nedkf7bux78wu1r34k5muonnjkrhyn
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B40E34000D
X-HE-Tag: 1793642752-703931
X-HE-Meta: U2FsdGVkX19f5t7XZYbCaA/R6I9D8VvRf8wWnvJ0k7d4sfhMnl8x66cgCjOznAj/Gr5aTullRb5+NpamcmiBgmCjiFjwLKb9ZS/Q85/8XYoA6I49BvXpOK8FMsahW/1YfobQkl/GyPr0R347Ch7CzLBWIe6PqRPIb8F8oORHqh2kOXAJnCtuthds22gZCFWfSEzMa0T37pctaWxzlsRWCoYGD8+OhWqeYFcyyiyjvbgNB4yoKIqTTs0e/SXxcFxxX8aglXBDfsHFHyMVz9nx4G2XcTuIo3be+Z/IHYwBkyFyvvsmt6b3Maz2Xg9ghQ+9mfK2voOrasDeacN9iOznjRZhglnb6dW3GYyvI2/mJwZzg0i0uqaVNqsDNECrgpfRqzy/PzFnE+sDhAT7HjSb34jWhBB9nfDBkEr23lxTMuvr5/cxXagI04kbDqI2V4KOljgbo1Mm6ascS2ZuWUunxMfZ7ep0LUFOr27EgVMdqOom+R3/+DLlsn9mVfk993UutTFr5zr+Yn2226bWehavtTugylMAI2HYOVV5F/vFg65ayYhXhkBFSdZwhMaU5Lm6ChXcZpFvEBvAT8/Hen8YC4dvh0Le/jhMB8QHgAhezKUq/RsXHDCGwt6cThsxsInv39DlW0Aq5XTCaWs5Nqkp/cbYTCqsHoNIg+TZ/HJmEQjuzpRNTvognRj8aK5AoCGmBWI7o2EFSJGZUvP9T7fYRxG3AnntVA5guk1Pvt+OIjHTflFIz+P76yAT0eau98aklSpMR5u5MO4S8ogbeLDlWf2bztrrYgy6Y0upEzpil7Q3FwCbPTHnjNsl82dIDRIl9G89y5NeyGu70NrrqFkO6NIwNCgU0nQ38p+1p7eYI0/YA9dFFNRrR1LU0BcSfggz0hhRb8JW3ikid9KOiuUWw9CwThddTRGPw1H8OYyKjmItb7o1FX8FR8UHcIRF/nNEY3paMogQG/kbc0rwiYK
 GxPSje/C
 ATS/cluMPex0YjSYDLhsiw3hmKxny3TA1IzgeMjEe4aRCziQikUTKnZRwMl9R2X7acJ4Rs9jcHlTsoqg9uPDnA7tjY+k3VhecQoseN907+CxQ+ZzgwexKmKo1wwOgfzJk+hiCyA8Tkm1ndvHEveKfgDS9/cqKSPRSrhLsoL1OShxHlkOlNCTFZshyTGftamRZEtJPZm2LNf83IXhUXfPdp0CBPxkqVQfi3uTUvSr2uccvPCF9uWJq18GGFn7hu9bj9MGHF+AegmY9OUK62PWmjgEMlgn7g0oeP3F+QJjyvjYY8N4rNoNKnXzQjWQYkhvdI2Rctu/WYHjMV3JKCn2T307pph1AOgWtVHxMBNSeNShu78SqGiRUpJlOMbFwdy1YFJR/0RDA5eKLbatjyCN4xvclhP+tS7ma9AKprLiKUt54KevTfSA1w7CWAcVQnk7L4JzP5mYNB3fqTL0Pw6oJmvXzWYWoAQDvWiVP2CUM1s5ugdv0K0XBjjAIUb4/RK/XwEDjhT2t8rZOXQV2N5+SyKkUblzMKaHe1K+kt7BkXMk1sCy6CtoNMIZAfJujvn8uD7GRwCmf30gXsUOIJyC5peeA++xt7BRDQmpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus

