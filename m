Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31181606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 21:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dRj2hloh
Received: by kanga.kvack.org (Postfix)
	id 2376B6B05B1; Mon,  9 Nov 2026 16:46:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E90E6B05B2; Mon,  9 Nov 2026 16:46:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6F46B05B4; Mon,  9 Nov 2026 16:46:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9CD76B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:46:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 665A91407BD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:46:04 +0000 (UTC)
X-FDA: 85416913848.15.CFB4E26
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 80D2E20006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:46:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dRj2hloh;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794260762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
	b=g+eKWgP/C6NRFpaSNwzh07L68uWhqG++IaM6oCQJJqxfEYITI4LIvAWUXXvhg9sOLczizN
	KNNt5tLZo58Sf2ikdHAbUEsgCdNmhWzILXe57M6nMqB60EzrX9dxkxEsQkO60t/EaNt2RM
	bxDCdm3JmqvjjLl9DFJrnTGRx3d6s3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794260762;
	b=A5EnJ6qDNS9sD2tc/CwePXCP5yvkJgrj8leSNVNh4EM9u+jBcaObcOWzVjRvnUn/lHgvFz
	Nhzyue8mp4OXGSSF9FGM5rpPuk/OOon7OuEXjnw+Mb+ChRrn699PdSMSLvZRhsllahNq9p
	Sq12QPTe6pN10XQrB6QYTNN04/BkzKY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dRj2hloh;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-490c1d337d8so966209f8f.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 13:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794260761; x=1794865561; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
        b=dRj2hlohCyQ01aqcOVrjbYmONiwgpEhcFnqasnoJ0rc4ugCHoZBS5nbC4A5CH6qvPK
         n7tJBwLPC1+3OaRelAz7zrX0rO1eYSvf9A3jbAOGEyaOgUVOQfMzQlPQ+HMGNSsRtLfI
         5bewHO4BlkrRqijvqIYSeJd7fX3InSEMyXiE6qsxfFLrL+K5qnSJ/jJ6xf3eF+3uc9Ew
         uF73sDO3+6Xnn9BG/V2McaA4B2ZNW6j9NuqkaO7z/RTGfXP5vMTuTqvoSGS1xTqwzhaj
         JFNzegmQXduOVzpWbiesj98nmEO24229GERWVG4X0cLZLQ6McTaTtFMV81mSQJ65/ID0
         Ri1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794260761; x=1794865561;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=874yjmK9ypxK94+nKOJ/uR1d6HpqK0owgIThZQA8ZUA=;
        b=JkU229IYlmu8l/xxQ1tRBbg5QwLBuJLPogEGSdHmN1xl/1JqqjazNIwGaUITCgobld
         ebWHLWwZK6lmt2wcvACzBs5+FV017Xz1Zyv+qTUD4j7asHspciA1/LCR3RCPgwHQgtuj
         2MFykbqIRIs5Rcg+FEYJi79GXwR90pcQAeVBY0pmJdMFRAa8OpDLfhYLxVR0E3h58etN
         V0dhdUes3LccO1/QAKSf69gsTj4Hw3cLmMdVl1fz1ZH+atc0/RZfhk0cHH8mAn5MSkpn
         KdFxt/5I8cA4mYxFuwHVWsMZd+laqFKwuPkk4V3sShbkn1dyiwE7GDFBSnl5lX427otF
         z+JQ==
X-Forwarded-Encrypted: i=1; AL+hErEnjhqYdR2+9OapcHjSCI+sMjcWCk5LSvAYGs5QMdWCUdAfcNvhgAH7Pc7AbSGhh+p+Zmb05iUQcA==@kvack.org
X-Gm-Message-State: APuU4Z85M+BaZVsItUKyAbz2/J3jOKNg4Ip3G9vRxzLHZZTgCyORPClP
	hplQqchrEdVAcch2JESbiLMdpIfcULnuB2srTpAoMEr+8GKtSG4kXl/r
X-Gm-Gg: AYBFou3/fdmjQ1yzuB/L1frUIC4Ir28hVF3hNGDCozkY8tMm13vPgnAbUAYhHgPt5Z/
	01XbD7LQupmVeB/z37YMUg+jQY1QJi+OCs4rAVilxjOLFxcq5iaiLRYsmywGk0pvugDIpAHlA/G
	Rwse4hVd5jJOn1yOltNiDHfrf1iq1bZZTzxk2FqpCxfvtfiZtKRgruwDITsjDTEIvrXxiH/vgvW
	QoXTeB6seyYHhxgZVWlRfsS7rZuw9YSKygbI8odTBNj6ijq6Ctsq8M4C18scR5oZ73DECSozXSo
	a2IJFTN0ri6yH9c42EKNMCgTa8Q4ISX3VhYN20OBmTlU1RPtoDsT3noQ+I/4BGx8t3xz4rgX3M7
	62sTR3D3w6WIALO/0xmuQ64ciyp/pD2zx37DnuhKG23RfAFE0pcb74ildaojwyn/h/wo7HNRaf3
	Y+huO/pGD1jVHnry/ImQInFPKQeU3tneea4smTj+zL22aF1MZ/HBRwvWXXKZe1MplvOgIykn5DO
	zatlHL+1y+WYi9vogCeiHSLb/2grwKkCcQLX0EFGl+8Lc7c/x0RShsZ3XXwN/Ifli7qNdHUbQix
	hM06ntJ3jbO+jpDP7CFZDLJOP87Jl4lSH/6HojkoNLJo9hUtEhPwDM13mJiJkl9aOw==
X-Received: by 2002:a05:6000:288d:b0:48e:25e1:5eb8 with SMTP id ffacd0b85a97d-4982b28aa42mr1487213f8f.3.1794260760763;
        Mon, 09 Nov 2026 13:46:00 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585c4fdsm1213644f8f.10.2026.11.09.13.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 13:46:00 -0800 (PST)
Date: Mon, 9 Nov 2026 21:45:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Christian Brauner <brauner@kernel.org>, Geert Uytterhoeven
 <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, Linus Torvalds
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
Message-ID: <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
	<20261108185953.28054fb3@pumpkin>
	<alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 9nbk6t5b6br4o3wm771m6nctjm1njrk3
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 80D2E20006
X-Rspam-User: 
X-HE-Tag: 1794260762-903274
X-HE-Meta: U2FsdGVkX1/SL7ndod9tmWpoxcznJR4fU0lOspBFXuI3GmSUjZ8xxPe+AoGsFIQCrYa+N9EzYSDahVuZBzefoGK1Bfh3QeCwdm4XOG8tqgBMH/oqdtjw5CJNSNxot6F7wOwmWbKpGHsWbA7RQTYQm0Wiu67s1qBUe1yAv0j3sEtZEg6j44KcwAuG/YJeesfzLDBlyEKWBqZEGGaytCHCA5toli0cPfTTAh0/mijKwrvkv92cqGxabxJfPlOH2+fj1Rj5jZPK6lSsBFPPIFAP6kgjwG4ipjzP6IlrDhp2hv1bjR4yy5CjryjDDYnoXK/knkxKGsgAG2AIxNjDLdatlFBM8Ygw2X1Z2NnNxDlyhTYofKCAfuuuCSq8K63enDaUN4i8QuvAWN4C4H1r+vSGW/+X2MKBcyXbQ7gcQ8Lso0DBVXeoFnmnjrSvhQNvLN9HbqzfyjZvLgWg1OeOYE+RFdZj6Jg6TbT/bsxxotNc2B8O50jo9z/Zsn7ofQ2vLCLoqTYFw4XqR+SHwcZXwP4feF/ENFt70bx0hEJVq+tTKIk11B27s7BZx62dE6TDzV1vd+1ygRt+RvdzvyN9JYrNly3StaCQiO64IGQBT8swFnxsEDQkq6HfFb9G9xBdBP29hRLAjK2EOwNAPMJUve2lphLaquK1sGPCt6sah5/gMZHcGsDWO0rytSg6zQKH1JwNbe3RRrx+9wqk7Cu4NFg+dRxiHxMbb8oZsR154Qj6pOcPW1Sd5MtQvulKku+SQwgyNRfSEVyWxWyJZRmF7AdcrEe1tDIGui7w9VUvzVOiuulSh4MkdMYZNJtEkY5Ov0n3g8e46ZhliZvnu9E0IagjcSTfJQ2PA09Ff3vNGLxOFI1h0IMM4HZxKzpdRxhH/muqPbFcFojuaePzXNl308AOz7+7N9CnvBDsIGubL04Y8uJPomZHNCajLAYtXXP4bh0SnGluclDWbGN7pt44tY8
 KMptemjm
 krBV8bfrCHsGqJd7izHI9pIsEqWpqerjl9gi5Fzjsrv+rH/PmXyxTTKJM1RbBs8lf9W3Yt8efIu/BYLjZROKh7VJfzclo7i2O0JYd7P8yt01RsYHgGFCJ44fB6izDW9sLiqfuMSfceOfW/LDLvUQVH183jg+qONMouDRX3cm5vu5/8Atc+u4RCTioP/9zPsByytAieqWlUkXKCoFFZnRdqnLm9MIC8EE3xWfb/kccTvMUx4QnI/4i2mkCWou49w4zgjvaAnaBM1aQDrA7JmOTcuHFuN0NNe+sRfH00m26PqGsvQFXufydDoYPW/yn0qdrPJvsl72M06FZiTWJhltI9ScWPFVgQC2SyVMBwUXP8KwccNL7NLL7J+jAhoS7RuJGGPHTWsuzJbJbRtErrhX8VpKcBzc5ioGRyfP6Wk7ITYGqhVY2IO167cFyP/per7R9R0zpITG9lHYnHCA0/OD5hjG6mGJVWxbXXij2Fnz7ltP4r3fZGHbKdVLNGPDGj1xjcQ//xicajIwbaV0smdzyeIwCBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 05:05:57 +0000 (GMT)
"Maciej W. Rozycki" <macro@orcam.me.uk> wrote:

> On Sun, 8 Nov 2026, David Laight wrote:
> 
> > > > While at it, I think it would be good to use this conversion as an
> > > > opportunity to replace "char *" by "void *", which will probably let
> > > > you drop several casts from users.    
> > > 
> > > So I tried that too. The thing is it drops exactly one u8 * cast in
> > > ntfs3's label write.   
> > 
> > Since char is now unsigned that one isn't even needed...  
> 
>  Please excuse me missing the context, but what circumstances does your 
> claim refer to?

Just that the cast would have to be:
	u8 *foo = (u8 *)bar;
where 'bar' is 'char *', and I don't think you need a cast there when
char is unsigned.

David
 
> 
>   Maciej
> 


