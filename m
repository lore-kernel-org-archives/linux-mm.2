Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7ACCD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:33:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7CD6B0005; Fri,  5 Jun 2026 04:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF396B0088; Fri,  5 Jun 2026 04:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D52A6B008A; Fri,  5 Jun 2026 04:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8176B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:33:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19299164376
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:38 +0000 (UTC)
X-FDA: 84845195316.10.512D991
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CAA3180007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:33:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O4Gt4MXd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780648416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
	b=RIroq8qB45WFw3nf0X2NcaDmuoxJMCRAYWxZd6asXlSP0seRFKfbiwhxsZ269OE7IDETIP
	3hDnf7uTcvYbylO4DG0cGfZKmh9kqgFxRdt6wW10eQjRBiE1ggPaBL+fsfcmHqExyJGYlX
	anyEURDQ9FkILYrxz6RD8Ef9dIWPKjk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O4Gt4MXd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780648416;
	b=FckiC67TctfsJK9uDwCddMSYypYLA5kkWjLtVZ9LTN+NxYl1rdEhtTEGQiRoquLgyUz1jC
	f0foiksvWKE/1yDkWNNPiPatnLf+3n6fsG7rPYaS1hTBpCXBn0meCq9Of5nTXX8at+QODV
	i8iy2KefO4sBMCOS7vdrSyCLHUoKXLY=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ee6d32402so884451f8f.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 01:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648415; x=1781253215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=O4Gt4MXdNEg/l0F0gCpYmJRhCOLx1tU3W5FuaUvsSTnzPn36mNbPY3etJ30RdLpJAG
         l6U4cDT0l0AT1+6O7qb+/+MuxecVxHK2l95iY/oZHEGZCwdgjB30oiM5AAbhW8WPpW/u
         iO0M2LzoDRt6BYkwRes6QlClM17089ApGgt0onOR3kh0seIeUjkILUlwWfcGKue4KI8G
         Fc0y8WJD9YaqtBePuBVqpLk9E4Gdy5TIjjC9cwOu2eWYPqUaq5+eqioUovoaj2Y4rVmq
         Wmz9Fb5VryctcYNEjY2hw4Gxel96IYQrpzgnC68NEmyqjvCjIvhHtcZPMwpxmxE+Yvqo
         ru7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648415; x=1781253215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h7EXbRC8R67rHvzXFjU33E64Dl9gsGtZbMHZP+ijZ/c=;
        b=nScmnyYf+/+BsQmuXhZURs66PvTuKi2H0lAz226oxMWTPNNzakC4KS8wj7x5pJb1Da
         QWd4WTBS3U6VOU+7jcugis3sYkb2Yrkg+PTkaxrYuOOo0Tj1UUnw4leq8+LV8pcMReKn
         6F5vN313iPizO2BWxFK0IVHEPxSUK2EJ11abY+pyOMSXuDaKb40Ju3iGBCPpAHxEHmeY
         7Vdz7XH9zakekj1yTjQe0/8UMY+NdtkWwyLizOtIiFWOOR8ZsVHzDkzgiRa0RM1G6WaC
         UHnXbRX7Opr9UZcnAKSmYRDMQK/dl1zb644JFwvTzlypXL8KVNdEmmMMU6445q9ONdLO
         yIjg==
X-Forwarded-Encrypted: i=1; AFNElJ8OuScOHPLSOANoVLdnGkgwpkfGyNylswzgwCHUHVwODec9MpGwBZfPS43GMWHi+UMTzG4eE1fWzw==@kvack.org
X-Gm-Message-State: AOJu0YzBu0T7vTR0PQ+Xhz5x0xP9XN6tdQL50Im+VzGWQz5nlZ8yBw7J
	CNcz0W8F3R5+oqhNk6ml1vU3V8q32wntrENXYWp8YLmVMyyqp2qPQq7C
X-Gm-Gg: Acq92OEOyDrx21D6jkCNyGsTCV8G8GeEvoAvBuHXyiAKZWU6uBF+0TtLzm+L/vtVV/p
	E1+mFuoQeE9kmrA4a/nEx5b+MObaRfgaC8Na/AbCKaBcmMzbsSKBgyaRyAm8puJB+UnwQlc7O+5
	FsdMaI7ELswyt9UhECMISt1OOk2JiEQe7gQed/EdmqwQLWLhZEJH98t23Eh1XRdqE77DkCfo+tj
	tgPZOE4QP1w7HY1jUHTnXE5XNkga6wL7PvorzLqemQDOn6yIJUmJsWDiRXz3znLLr1a7ywxQcM1
	0pBjw8eS4w6BcJHv57HbDy5Yv6Hqmxba/uVkRPUSZsYrzPE4M7/lvxFwrhCpgk2YF4MCrtagv+/
	Lt3gfn+yvZLcOkO7lUl/KTHocZMRKEuTqsxaLYVRy1Lyfu9QaPFlVNqz+Cf5B/wlvhoAnpGX4G0
	rybI+0d54sc7xY5zrwaXLauxby/HSPxUD36NGJprhucVkvSn1z75F0nR44YffIe/IpnJ9+7tA=
X-Received: by 2002:a05:6000:1288:b0:45e:ed7e:f8f8 with SMTP id ffacd0b85a97d-460304f07b8mr2783510f8f.8.1780648414528;
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2e4004sm24140153f8f.9.2026.06.05.01.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:33:34 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:33:32 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Theodore Tso" <tytso@mit.edu>
Cc: Mike Rapoport <rppt@kernel.org>, Jan Kara <jack@suse.com>, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Joseph Qi
 <joseph.qi@linux.alibaba.com>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Trond Myklebust
 <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Dave Kleikamp <shaggy@kernel.org>, Miklos Szeredi
 <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao
 <leitao@debian.org>, Kees Cook <kees@kernel.org>, "Tigran A. Aivazian"
 <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <20260605093332.7b067876@pumpkin>
In-Reply-To: <ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
	<20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
	<yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
	<aiEX4UTxEnBTjVKo@kernel.org>
	<ximvn6jwgtam665a4droqkp73o55kwvd5uukyidwjesmysobth@oe7rigpsjfkz>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CAA3180007
X-Stat-Signature: ixazoeuknw6wwhw3di3jafp835fe9kxd
X-Rspam-User: 
X-HE-Tag: 1780648415-574169
X-HE-Meta: U2FsdGVkX1/ZFk4Xy1YKzpMFcmpw0ZdkMBWVhH9ONnceFnQknGjzj9dN29TJQvbXSLvWNnk3E6M4T0nnPvvfTotShB2X6XQvj31NMYspuD3gwBw+IPdDtt2IM8KfMazOz4mmN3HC4WD0TuA57xekylnsbzTYSmBXb8KcGqfFV7DnNFRBp4KMGhCuf3VKQeb9V7XOY35ZenntdX89SQDkdl7GPZR8qc6bap9lqYfI2S+TNcgnRvvYbDu9CT045o8CmnAsMM9iSSYjIOm8rnc8sqWs5X1i8doV25NonhpRn1dgUr6xqdwgNJ7BGrtgvniyxOaZVAR3bPwMXv/+1jzre2tUpdk0SgTOS2vkd3WrogDpKNyJfcyWswUtWqT8qsW8Lm10K4ho86Q1/EVUjOiZuHUSVCvoDIg+5jy0kGol10o7Np5cDeBVlUo6dsCSgF2B2SqYWZMhI84GyJSYPENQlbiKikX39D3FW6FdZB7aEieAhwy5oGM72HTqgafK8rhDLtzrFRFEHnxGfBGS0DXFDx5kPWJa0Ao9GNLGeIRkhyVBEYkhEECpUYGU1BhtAPH5AcMKe/kMiKlVTTtu8GjraPmidOgHxm7VbNIcgd+aT5r57MKnITMBVTOAsDyV0dx4cJ+JYuMiEKnap3+jqrDs4Mjvfa5z7x1uFHJfqMheSTXdGD3lOamvct4a/TMF75lgs4gfHSbQwTFxDuLLXCQOw6CZz/oCuJoS0j++m/6ioXjojqa3zAsioIJSvDAu49EcipdV3h/gj51UHPaTLgxo1ZSQwxIm9WMiiN7nEIBUM/Otuw27taJIr0QmBLrDqo1tbz1QlaSk7IkOhlOIFmdHPGM78XXL/oO1WZdE9W7PpAQ8KKpfpfx3mxs3YZPjsbItuT2z9xzAf/wfL5AcxhlMsmHguCqYOeWr+dsINaeNpdYZvQHIgoIqzDabmxSYtcWKuCYL0zmzJ5JJwDffQXs
 z8DTSRJn
 Tq7gZAa5fhj63zQMsz/uVPRDT0TEwRfVQLoo8bc9sOKdwtBoKMpDQOTDThWQLVFMchOrhCgOQMfwYzZ9UHL5SpvIKhUqLrO0/dXGP8LHPqq1AieZB0hGDNlOoxpNFdha1mZ6xAoNWvDgX1igkui+cM5tlS021dgRnpSoDJbCt8OrWuCAsHp0S5kjTvacBGw127PTUXmevii9cnAcRYyRXfWM8DvcV80oXDabD8O6JNWMBwrnih0917xZNHi3Rw7wwYAIfseo0NtjWbnM+p4GxX2AY97yistv7TcMlN48Pb9wXGziHMH3HoIR71I1SjzWC/dZj7nywLiug5XCHEgvqUMg7cgHlI+POJPObX4jVs1Cl+T2ZpkW9ko53iNZSeW1blP2s4ugnUMbOvkCiSd+SJAZXBJrJAAJXGP6GGdOl5R7fY81wCziM9hgkaAQAzUuIfLqTrkmQTRTojPmLsxPkN5OK9VoIXQXa/zURzHUSA3SvJtPGGEMfSyfXv5ITCtUkn22ixlqyhpBIces=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 10:05:52 -0400
"Theodore Tso" <tytso@mit.edu> wrote:

...
> I suppose we could do it with kmalloc() with some flags which to
> prevent forced reclaim / compaction, and if that fails, then fall back
> to vmalloc().  Is there a better way?

There is already kvalloc().
I'm not sure how hard that tries to get kmalloc() to succeed.

-- David

> 
> Thanks,
> 
> 					- Ted
> 


