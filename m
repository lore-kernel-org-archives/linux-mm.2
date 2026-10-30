Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62934606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZiovnmKr
Received: by kanga.kvack.org (Postfix)
	id 0DF8A6B05B2; Fri, 30 Oct 2026 05:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091096B05B3; Fri, 30 Oct 2026 05:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7636B05B4; Fri, 30 Oct 2026 05:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFC826B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:20:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DA4A1A067B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:20:10 +0000 (UTC)
X-FDA: 85378746180.08.8729097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA74B140007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:20:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiovnmKr;
	spf=pass (imf09.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793352008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uyCrS3trZJ5YkE9uiv746PMfpKl6S+0MjX103j94QEY=;
	b=Xry8klfrRMDBUuCYiBBFYRSmSNdtDTKqDrEhHmbLPGvYqDIkcjRqktLfciYLkNmp5QGV3j
	ByV3fo3Sj+vLYo1oZwbor9dTpcqa7fTNSNvE+ekal4O5UnAep/aRkGBsP+1s4Ya2z1yzMn
	yEVQGOW2x4enjgOlpaOitHhEYsg9aAI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793352008;
	b=zP3kd0IV9L5GGVb4bRyOJo4245L2TuEiGYg262GNx3G7/BGpNhRApXDLwlmeiH0j3T9ac9
	P/KNIFwjga6jQv7gdD48TrcFwGBM5ZXUg43YVOr4UrNh4g2hrg8Ll/DJHwYZdCCEsuLnxS
	ay2ZfGTRdzkST509JhIfGlNbnEuy2zw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiovnmKr;
	spf=pass (imf09.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5764A60617;
	Fri, 30 Oct 2026 09:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650CA1F00A02;
	Fri, 30 Oct 2026 09:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793352008;
	bh=uyCrS3trZJ5YkE9uiv746PMfpKl6S+0MjX103j94QEY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZiovnmKrsbRP2VmxkyKnd/smnpW9g2XeHW0OgwBRw81hFTmlrAmSSvb3ln6dSEnpS
	 ELLxvhCk2YPWZNnGj1a2svlnm2Na5/RJ4FOkfREQuyZ9aNduDaW4TwX4bbf+HFDNvO
	 ZOW3cwjUdvtUc0MBnsN2cT+qrQ1MNpIwWR3+JWrcj0gXh2ZJxhXcFodPEAbFHB7QxH
	 vL5+HmXsf1mA2ITlitEbSNIr5z0W/a1kRfCOwKoMcla/Q5jot2XcbOaq0qvs6pxPJ3
	 8WimzQ7l1rfc5b8a6lGS5lMdHJT3JFOW+bs53Ca2UPZtIQ/R8n/v/3EtJUJ0JpQrNo
	 k/2vTfw6psolw==
Date: Fri, 30 Oct 2026 10:19:27 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, Björn Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur Özkan <work@onurozkan.dev>, Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <Julia.Lawall@inria.fr>, Corinn Tiffany <corinn.tiffany@inria.fr>, Liam R. Howlett <liam@infradead.org>, Philipp Stanner <pstanner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, Samsung GOST <gost.dev@samsung.com>, Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [GIT PULL] Rust XArray for v7.4
Message-ID: <20261030101626.0-da.gomez@kernel.org>
In-Reply-To: <20261012115028.73246-1-da.gomez@kernel.org>
References: <20261012115028.73246-1-da.gomez@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Mailer: lorebird
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA74B140007
X-Stat-Signature: bt4y6pczcewraejg4yb6f51se8wbeun3
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793352008-558526
X-HE-Meta: U2FsdGVkX19whP+fh86yjuzATP8VnR3INCW+yRg7H8LMeyYW0YLjawQWmVdORrjfPK88MsuXEHqeOChPlpEG2iFdmOvcwxzFB9g22KLM5qgBVU/DskmUs0lZBTbjM5wVcKgEXtpFvqoZZZglhJhBhgTzJWzumX4NBZleEkxKAm+d8KevTyN3wh3TtHQe7k63PcRRb9NAyhBddU297Gd8YvhvVHoiYYpamgirlduB0VHRfXvWPfaXqDNy7dkAqJakItzsZkqKRG4PyWmq9hedig6UKutILnsibM3SeBExH8rG7HFYxK0Owxlsd1efF5rHOx/OOKhHw8aTtvzwbpC830EhE9Y2Z6KN545VjtXWQqfWFTPuA1BritX8CYGwvgfXYpsJrx9LDcuz3CAw3nq8FX5z5ijUmqnyfb44cwCZQPPhtmy5Bb6LZqPVTp2E1nRpyxccOw/aEvuRyCF6IFlfMCxRcnrhJ5H7VT3m9HFcVShGv7p0gx9lCXr1r+RtECQWjYMsUUkegY6ShVp7bQTz7glAJcvEW49JiqQqn6mOE8xrJRYRqCGtnphqU2FAvynEi4L8og4mtX2tSUsj2HekYm96BwHwSJsd0M4Nv0I5TKE64/kl640OavrfhDVyY49CliZy9mFg4h/VA/7znhqWrLJeEfJZUG2bYQ7FeIHnSd7r0TSna1Sb9b2F0vQgTcSPuOQtqKTXfGbCNJLNut9Q14HUom30V5OuXB8cJs5TUHS8KRd4Nd2kn+1ookw02wn00QEieL4HYZuXcLKhjxnFYLjaNsmo8uAZKd3wjGy2Ssh3izn8pntzX2lHmeI57KPUrUBu8qdykwRNiisOLqITgWsH8k/CfAmU8iJOf5thyHX8RGmmPfhc5sUIHZCNBBC3/9nfaRq8qHgCXd4usKck8Sn8iMjjtmen2gUaoV4K1n1GfyjdEB0ZkfLQBlz2UpDZ1bhEMmsv+mXAXhocgXn
 9g4t8lh7
 dim0A/znEaovLH+uq44aSot8INshA+HLqWM75EXPJQyWBnEUCJoeja4rsl+hZ1I/DjL2MQgATwIk0FcqKHfWxE+NDy91HBf8iUYKQ7EQcGSLC26+3KyFDeulwkKZt3yGUv80G1Iijd05T+8zRS4j4kZsi4dSzXZis5vT/MkkD/Lwvx1/7sCWPX/SuBH0sIxEcgEiHE6vfKJlmySs0hsplXbho6Yd0Gf7OAzUqUVxzsMryMdyecfVxa/dye/d03jHxYSNRvfSUQH6ofSu/wU0j45zA8Cm0XJJ/FcUeDryL9oP3mTrJB1Mttg6ZNpVKheOlhf9bu+swfhZFpm0HlYDs8ANQz8fFnyVlxrEaj5MDYq5y3yTnG+NnNMEQbFHYsRaf9Bvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-12T13:50:26+02:00, Daniel Gomez <da.gomez@kernel.org> wrote:
> Hi Matthew,
>
> I'm sending the Rust XArray for the current v7.4 cycle, although it is
> probably too late for it. Just let me know if you need me to resend it
> later, rebased or under a different tag.

This missed the v7.4 merge window, so please drop it.

I'll send a new one for v7.5 based on rc2. I'm also asking Mark Brown
to add rxarray-next to linux-next. Let me know if you'd prefer something
else.

Could you confirm by v7.4-rc5 that you can take it?


