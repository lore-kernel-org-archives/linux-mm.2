Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C870ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3651D6B00C0; Tue, 26 May 2026 11:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BB16B00C1; Tue, 26 May 2026 11:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2786B6B00C2; Tue, 26 May 2026 11:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 195C06B00C0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:00:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CDBB040423
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:00:33 +0000 (UTC)
X-FDA: 84809882346.08.602BC9A
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49259A0011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:00:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=hc16EJk6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.180 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
	b=Abilb/406aFsHID5zC+H2sqR70i5TLTy/E2H7RdjmdjjnIvGez+S6Icj1LOMJcaJmjBjJO
	H+q/3WHyOV9nGhiXFKz2nORj3W1d3WolOga48ImG9oFL2eJRne8gUAJjQIdXY2KeH1YE+2
	stB5DnEVQdrkfpA2ZKbbwCFVsC43LPg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=hc16EJk6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.180 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779807631; a=rsa-sha256;
	cv=pass;
	b=tAX4mPYcfXsuFzlFfA3CHkNi3NjG6UDaxO3Pu5Tzi1FENNAP+5vTLmEEy/sYBMmaHNM32O
	Uz/+O/xVKc1JzSjJHJi9KuMxgCFgyB+MSm1jLByWcg+zaH+EFkuddj11ktR+S2YYZbXB2j
	L7wycmtgWFXYItwh1+8u6Yi1lQf4Uq0=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-90fbf21d9d3so1638710085a.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 08:00:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779807630; cv=none;
        d=google.com; s=arc-20240605;
        b=YFYFzM4WPPhzsD0YCgRRdkqwPp2EsguaoL6d78x5GF4scgXPkXy9KfTBCOxZGjdVE8
         shSSB3ok+RhMk3f8oqxtZ5nqbu2rCCKvLw6KVWAfX+D4W8p5SuQWMfZ3QgOKb0fs1Gh/
         v6udUw9isvWnqcRrfnkvjn/JLGklcJqVkRAdIi6FqRqfVDLFmbCzPDwOxgeIpeaLnoQr
         IwLnlYaOqgP9fuDBYuR5EuPpx88FZwWYOqr2D9LUH5pV+it+/9ydB8s3jwDPYfXMB/LX
         VNNBhyfFfOt3hqFVRmJENeZHVVVAAA4B8kKDl++G0nPik/DSDjpHaYkUOeDXuRGEsFgj
         bk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        fh=9x8rWueLnrrDBhpSfvaBMoEk+WCBa19+zf1SIlTCvV0=;
        b=buzc598NjC/izS3QzA+MTdT0eYRckRkmQ552Xz7muwaUvokV0SQe3vQjZWMilW7cYo
         ZIIzk4s/al3u8iLG88QtFfgyoKvMQt8Z2U8tkgHhRRMAcPFw3llmANdFS5orpTeJS+n1
         lnr7rln13MJUIExWRH/UCckJ3HSX615yfrV6BXzXP5vLMBblDyEMStMfr0ypTFp713eA
         MufW2BzX4HyPrFRi+BWFBusXZzL8PfTQ4N5huBlYwOL3ZWto/JLcruMcHiw8+zk3UPAc
         xoneNzIQ4eMvdwC+ebNUlDk23opMafG3SvXi0yCh8JgAKJA+s5wT2yEsuaVaRekQ7Tai
         Xsxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1779807630; x=1780412430; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=hc16EJk62PGWSLfF7XCeWZfVV35V/i3f4uIrZ1QrGcLTyHrSSxG6ZHucugZxEYjxhK
         HOY//qiqNjhINm/p1FUnSkcMzfnKokIEXO/KUAKawF2MHQZ/BCqn+17FAal+nHT95EUf
         YXAPkXRXe8rcNzeD46nzAQpOiacoQkxsTyfY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779807630; x=1780412430;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvbsFrM1aOZoE9rzekiebiw0GdV7XyQJiZp1BOpUdEc=;
        b=HyVu7GeOMi05vV+ilAwKvAtusljo2oZotc4RXnncuf1OgGoJvyh6S83JdWQvGx2/uh
         /nBCbqTnsKecGtkUD/vNKXRSXt3BkEwZDxvr7v+icvTe/hLXqbpK0T1G0FB6PyGBpZ55
         oluotdEYoUt4uwod0osP10bB9orZiHcot7XoMdCMyLAJFYufVvpsZvqGMO285I6LEUWO
         Swh7F41E2DY9gB/dMR4uXKunGErYvfZ39qdBrWzZShCkrxkcw7jCZE1NJ5wLC0VD84HP
         eh9Sm+Ed1xT55+O5Tbk98JRdt+z+TtNCZ0RdhInBrhqpFcPi9zxFK2HClIUZZU70XGFR
         9bFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/r9LXG30LLIf/BOog6vh0rgY1weZ19QQCie1Nad8nmwfE+rD9QWlIZh2fgt5pN9OOV4cGFgl+cAg==@kvack.org
X-Gm-Message-State: AOJu0Yy2R5Pcma12a6jMNaLdNDHZPp45EFb0CwXH4AAWgof11tNoh2bW
	Tl5c+Uo5/t1duKgSuL4Bi3zZha2t5jNvNgKGJATm5n9KBGnwbE/5md88/8oe0u7+f1ZnKrQEZpS
	4bC5U8dYGAiA/2YvMjkRx7iPyHU/gnSaYAgJ4NmRISw==
X-Gm-Gg: Acq92OFTD7SZ5SYguGWLpKHEUeYL3f0C96gRFbBbE5o8m0mUh265aibtFWQLXMx+yJu
	mtq77tbuydTOswS0jsFuCQKJv70ld2CJRnYWVq+Vgi0iQ0FOCRAmJ6Be2/EoKBIJLHIAqYcseUf
	TMOuMTnIamZ3J0C2RpkzGINmm+NUNCGIdXxxdACxlCEqqaN4Q9oQlvZQLIVA6JgEi07vV6EhkyM
	vlu4RGJ2TI7vWWUNk5e2UWSeddIuE+5HI9cFUcUH3hDxoaLZi61e5mkrN2KIFoHpo5FXT0YkIkY
	e+EaVsJCOSsBnX9SWu+rH/dnP5yr+UuNlRudEALqbSy/+HkFZA==
X-Received: by 2002:a05:620a:2a14:b0:90c:e5b5:65f4 with SMTP id
 af79cd13be357-914b48b5d36mr2776455585a.2.1779807620596; Tue, 26 May 2026
 08:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org> <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 26 May 2026 17:00:09 +0200
X-Gm-Features: AVHnY4KilITCIvGtFxS6FTciw1vCUm1AhcuYlYRxf5FBmn1jF7w4ka-Ynpxrnvc
Message-ID: <CAJfpeguR8uzC+GdyYfby1LS+HyB=p7=ri3J4aAmUFfZ2V06+1Q@mail.gmail.com>
Subject: Re: [PATCH 12/17] fuse: replace __get_free_page() with kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ze9zarpxh1hsx6ceaxj46ytsyowfxqr8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49259A0011
X-HE-Tag: 1779807631-858969
X-HE-Meta: U2FsdGVkX1+dhX9Yh9t+w948Ge8/UHWS7+jpdh4DeKV/awp3Ro6OsEPETdsaKBmZX6YvF+UzEDpWSLtH5kXiTILzb9qlDP+ff9JjeAX5/ui8cdU9pV6nJoV+dQlIIMDdLnimtLSdbuAC358j1n4foSMBwrSifgmWPli2WKLnn+gn4+YBpAkN8KvKif6V/SUeZyiXzgV0k3JKl2qkxp+yHbMOO/KsdwComQ+DO1dMTm44JjJIho+SixGzgRAD70MNMLQVw6MTuH9qRK7lZgYFiGVW/VK1LD4VugRtvvqTr2tvq5domiceW0Vuy7T2qKbmJMjAouUcJfv18CAdU3qXhxn1O+8gPGiLyN9uhBL2oQoxcmTGKKZXb343Sj6we5DSFUk//6qioGzyF1pxYgzSSRpB7845gP+Hnu5wdyuYPaDLupvqKRiT/30W633dBRK6L+X58UqnSy3k20GoP92Xz6VvVupzTloFMGl3W3DP6+tmPmApWnvcUi3XzIgalU/wXIO7rrKuL7/QATbEJxuTiW/mP121Pv5gzOoMgp/VBDulvOQO5KSMxptHD4TvO8KjZeRe+e9Sga63vQFZ1trZq9zSsTODroVyilDyECD8ZU9CkQfauOCGdliIRUHSywKF7SfQI64hCHyUZPQck6+VIoltTOxhMI1B1LsjPa4yfkKLrg+joVQBFlGaWQJ3umtCjIfMSQzjSSTioKy6Rds5Clp/Hj/TsFapPG+LQPROOHaa+uajeTdao8TS1uk6iZ/twwI9eEAZop43kUKq/HMRe6z3DWXT1HYgc7jA4LpBAcZN80VSJd0Rmz+0Ms2m+JJyLp960RpWW/AG/wWPftBezSHJ/wj5lzExUrs7plHkASM453ZVz69HGga8tr+d22LUT1oiwDW8bvuSQ0/pVOQGlVkKm0hb/Egcbq4yrqheICUh4gLqxpWvq1NxYmFxUQdqu2pNHcd2eqjENuq/t10
 9Fq5Olal
 T9Fd+moKvBOKqybxWikKebE3kv4v/KsIn45DvsSxW2PEZtk/Bxc1T7Q2YQJDOtSO0znHtm51aa9GZBjQ8wI8aU2gq2areEUee7UCTRSK9YwvXQL9HmqJf6sPXRInoViSLAk7o8cA8Eh9EqBcE/AP9aOVAsiREyiDSt1tc12f4eFaIEohOzDFWOIBV7SH0JyVrbOn9ugpV8z0UsgFaVlkcdJ2Ls7jqv+a2tVpp+wx/+90MSOp7Lz4sLsZJEgu8+G749OEKfR71g/nCfkEX5BTJnoIrdtULmGDEEhNSzJffUSmRS7ga3x1P439/u8n+IAMEjdpFJbjjCvCWaM0WnGRtUsje/dFfNoQ2A7kjOQfK9mM8W6CXhSaATr7EbUUFUI5NFbT4qEIYVH2Web0EatjPEU/15Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 at 19:56, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
>
> fuse_do_ioctl allocates memory for struct iov array using
> __get_free_page().
>
> kmalloc() is a better API for such use and it also provides better
> scalability and more debugging possibilities.
>
> Replace use of __get_free_page() with kmalloc().
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos

