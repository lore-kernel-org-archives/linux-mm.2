Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606C4606D83B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iU5O51DC
Received: by kanga.kvack.org (Postfix)
	id 4227C6B05C0; Mon,  9 Nov 2026 06:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ACD66B05C1; Mon,  9 Nov 2026 06:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2757A6B05C2; Mon,  9 Nov 2026 06:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEE686B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:27:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 040CF12062A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:27:38 +0000 (UTC)
X-FDA: 85415355438.12.030D345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5DE32A0007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:27:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iU5O51DC;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794223657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTe3rVqqBFubJwfvXPNDDRZX+sidHXepwnZzWomDy5A=;
	b=ComcRHnt2eE9Ee7esPWlxvPEDXyMEdnSAaKyjHi9jwIQbXOKqgPOxvQZhi0Jqp6AK5jbgO
	pnvnmrJZH++FySN3F6R7SBtfTI1wJp8gwBZBIgX56UzM1nLeIX21k62h52qF83XSeIq2NG
	9eT6Sc0GNnXuj4IkFB+g0hLc32LEy+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794223657;
	b=ZU9St6e5ecL65eDyhYwL3WUfykEndtU3FIxR4tLsVVmeNeEASvubQ+bbR7XUadB66Iqqwq
	quZAo3ViFOiDZd4mpqsXtycTa8FnJ+391aFlpmNgqUG/nPcSDX3MIkR38qLaBaWUpyYkcL
	HMnXmD421kSFiU/I9vpjh/fOo4pjkeo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iU5O51DC;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF2E9630DB;
	Mon,  9 Nov 2026 11:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EA41F0089F;
	Mon,  9 Nov 2026 11:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794223656;
	bh=GTe3rVqqBFubJwfvXPNDDRZX+sidHXepwnZzWomDy5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iU5O51DC6zVVQKzDHuys9tIxjfbSOhYw8z0UcE86pb//wkXavh32S2N8S2PUurU2A
	 o1E3RopKG7W94xtmWo25LA834OkIsoplK5Zc5sWRxNqoMBKXFQxzncUeAVAHVqzYUN
	 x0xzl99BebTVjgItzYyFM18S+rvSgi3xMyTZJ/jJZ69X0Gf56Vq2vszIAP9EEsAUq5
	 YP1A5SHoyPmQVAQUq/DaV61yYmuj4yVaaeC+HIcZMJhadQiWUxN4AW86j7fp4xdZK/
	 SKtdAofdOgM6AVAC0cEZ3+8Z/6By8LpM/kvwzBv9E4RtCHAt3TdDxZIlKuxADBPb0I
	 863RWmyUQ6DWA==
Date: Mon, 9 Nov 2026 12:27:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, 
	linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
	ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 07/23] proc: let procfs own the seq_file of
 seq_file entries
Message-ID: <20261109-atemberaubend-begabung-bedienen-85aade0f99b4@brauner>
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org>
 <20261104-work-procfs-core-v2-7-76ace653a773@kernel.org>
 <8A21EE2A-F392-40B7-9152-CBC440FDDA70@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8A21EE2A-F392-40B7-9152-CBC440FDDA70@kernel.org>
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: i9yp54sbf4ehgwfum4rfrew6tjwwboo5
X-Rspamd-Queue-Id: 5DE32A0007
X-Rspam-User: 
X-HE-Tag: 1794223657-807461
X-HE-Meta: U2FsdGVkX1+Nkr12lj1Kf2rIhSzobgq+UNX7Xqi52QLfTtTBg/6f3PDFpV1IYAVLlDKBMQd/Wb9aqZ3//m2GEOawQwTrhUTgdkf/C45b9MztiJ14tvnsp9lPrVQlw9/letRs6rKZgvxvYGLrwxDgx7AdDSXRZToxR3LxjpEb1ZJSd7+TBxR4fR+WXZ9g9MDzY3e2GQmUzM+OHUjJouOzP14vRzEQW/TGmNuJ99gJT18mkhLLG+SMpsTvZ97Y8pVqrp6kveFF/QQoOKObgwOHwnaAHaFOJTjgt+woSQzeUZo70a//dsQwPPkQpBjd0vBA5dYdw4rLwStoFB0XLNbNnB5YiIHW6y0TJGpgLj3c5sWGGZegEQMsaFjxrU/g41qA/DhmZbyxxDDcxrofZfdd207EDfysZNsZgSEFKgtIZpKIuLxrWnhKAmECgyofSu2HW1veRe7/X8x7WG0LM0t+82RTyTlGvRmbx7fLBE/KKzFfZTJl7gD1+14D/F91VwdznJQsCJFuakIftL8x+DPu2ulfLzHrjRJ5kQkjxEaVJOF9SRc0QmeBAezZnhHUoDLw9MCIIsx3AN4Q1gHmljBdOAtMRv+haI/P6kRORQK5Zzj8pkH1s8M4/Fq+pqs5mE8bUIH4jz1U3Vo1h2GoEb/EcAQjLCSnFdp/v9ha2GK1ik3WBa991aZKtLokPnFfEkvzvkBIExZDeV0dvPTk4WzQ+KFtllZAZAR7IHaGzUk9qEgMERgyAoVCvUbY1HJOIlpN9oA7zdDAfIPSMXULDrno1+y8VCmjeR8zgj/xJN4JtXSrJgu/yQG5wd4bxYG7+u12y5KD4AC7VycvL/RrDzkL7I4PJwD1w3AzG4gXt8haO+DT6F0BUKWsO2JO1hJibX0E9SHHnk3eeygIkb2tm3gkuloEH1va2N8M2SfuSUmvGRe+/SfWjy5u8hyeZ/y4tGYa4YZ2YQRCg3PMGsPMr0P
 Ujw5IMMX
 W5ZO8eoOYoWssrKC9H5VKw7MA0qpdEoPvN424Jfphz8qXKnIm+5dOHWMfCxjOsz9GbuTbcT/6qv0M0e3UTJnVi7h/Y9JYjEPqGPczkQJf6W3ZBynasflPxf1KLTL5NiXYXNOecJT6IRM3ExCIDfQBGvJlYmhJh/do5gi3SL6Ndhyn7f50ZytFpF36aQvjWi28c6a+AT+fhAqs7WKgNs51QntfV82UOeBe66r1GF+U/UYAOjt9BbjqINd/tn8oSscLSLZ8UiwdYcx9TvjW8Vq2G0UQvCsmCnZj0Z6ddBgPHcho2Tubi78w7u5NqqPFOjo3M0Glv+9CKD6hFTvFsd8mrLxJ2Ip3c4XV90F3HibuYTuosEDx93z76F1KXy9k5zOEwldN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 08:10:28AM -0800, Kees Cook wrote:
> Please use the new style typed allocation calls for objects:
> 
> ops = kmalloc_obj(*ops);
> 
> (This happened to jump out at me, but please check the other patches for this pattern.)

Done, there are 5 of them in total:

proc: resume readdir after the last name it returned
-		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL_ACCOUNT);
+		cursor = kmalloc_obj(*cursor, GFP_KERNEL_ACCOUNT);

proc: sysctl: resume readdir after the last name it returned
-		cursor = kmalloc(sizeof(*cursor), GFP_KERNEL_ACCOUNT);
+		cursor = kmalloc_obj(*cursor, GFP_KERNEL_ACCOUNT);

proc: keep the open files of an entry in an open node
-		dp->open = kzalloc(sizeof(*dp->open), GFP_KERNEL);
+		dp->open = kzalloc_obj(*dp->open);

proc: own the wait queue of an entry with a ->proc_poll()
-	on = kzalloc(sizeof(*on), GFP_KERNEL);
+	on = kzalloc_obj(*on);

proc: let procfs own the seq_file of seq_file entries
-	ops = kmalloc(sizeof(*ops), GFP_KERNEL);
+	ops = kmalloc_obj(*ops);

-- 

