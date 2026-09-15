Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4432EC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CEB6B008C; Tue, 15 Sep 2026 08:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503BD6B009B; Tue, 15 Sep 2026 08:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420F06B009F; Tue, 15 Sep 2026 08:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261076B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:14:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7132D8021E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:02 +0000 (UTC)
X-FDA: 85215888324.23.F70847F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DBF1412000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:14:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvwdtYpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789474440;
	b=CsXZr26IeXpG8Wj5+eJWWgA+3qjL1LXisASNgqFhHPGKFpkK09adbJpe9xX6a5gcxbx/EF
	tsqCBYLmnmL2dd52g7fay3kqURE0lGZvBhacAShdxqxgY/RO/a5Oab43DvGG5LYpKfj3Sk
	UPe4fsBMTgqZfkFnlMwZrsq+sMQ61hg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvwdtYpl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789474440;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/qDC8w+78iGOR02PfeQ9lasCpgoFwlOJHnQ1mx3Dgc=;
	b=w5pXLYZEAFE6IXYKTk6vcCYHe8jTjiK8GN0F0WNju5HpLP+Bn3aPfgcR++ushY7vFYo13Z
	j3WV9Wtf4AVTcQPt4Ss247CAYK+H3m2QzxRLr/AficS0OekiU06lXr9UAer/e8gJbOC1ms
	o0BjX13kkJDqeD2Ew8rgcuWZ6Kv9Ze4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 108AF414E2;
	Tue, 15 Sep 2026 12:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2741F000FF;
	Tue, 15 Sep 2026 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474439;
	bh=N/qDC8w+78iGOR02PfeQ9lasCpgoFwlOJHnQ1mx3Dgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CvwdtYplEMqh0mXb9UtTtEzUPZjlErl5BgHWZ3BUuzKN64/50zHMmE8tVi+y1B3X3
	 tAYkfuPSB1IfE0nhCXR7lcqXNSl51VqpY+L+oymG9YPh17XOrUi8G3/Aa+dnQeYFRj
	 NcQX+8avtvTCjCij+9TYtbgkkb7afe60hNSTSaGvh1L3t7pyiz8fuqxatGkMKmaKvM
	 8XOgUv1cgX6wWpD+3GvwOhIJtw3OnoMVeiRhGh4LZXzdsV358kdYIG5GabAq3BtAXs
	 I7hVAiVBYRClyrA05Lt47fHM9pl9LGtyPE+6dxCTPgbrcsy0AbO5y7C+JwxLWRY8kE
	 FeK/23S/8IuyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC POC 35/50] ALSA: compress: install the task
 descriptors when the ioctl returns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Christian Brauner" <brauner@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-parisc@vger.kernel.org, =?utf-8?b?Q2hyaXN0aWFuIEJyYXVuZXIgKEFt?=
 =?utf-8?b?dXRhYmxlKQ==?= <brauner@kernel.org>, linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, linux-mips@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-hyperv@vger.kernel.org, "Michael
 S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, io-uring@vger.kernel.org, kexec@lists.infradead.org, linux-m68k@lists.linux-m68k.org, linux-hexagon@vger.kernel.org, linux-alpha@vger.kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, linux-openrisc@vger.kernel.org, "Oleg Nesterov" <oleg@redhat.com>, "Jens
 Axboe" <axboe@kernel.dk>, linux-gpio@vger.kernel.org, "Jann Horn" <jannh@google.com>, linux-um@lists.infradead.org, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, linux-snps-arc@lists.infradead.org, linux-csky@vger.kernel.org, "David
 Airlie" <airlied@redhat.com>, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org, "Eugenio
 Perez" <eperezma@redhat.com>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-35-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <20260915-work-fd-reserve-unify-folded-v1-35-4d5217d6b246@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 12:13:57 +0000
Message-Id: <20260915121358.1C2741F000FF@smtp.kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DBF1412000E
X-Stat-Signature: wjs9fo7iducjiguqya3hid3oyg6qxx87
X-HE-Tag: 1789474440-221082
X-HE-Meta: U2FsdGVkX1/cSAIVVPG/Z3o4hvI2wpJMfjNx4Q0oaIN/8xYEvvTwxr7D3Jpt/3QRrW7wNGjXalQZ3RTLK+zb0d5raTucX0v/qG/MDNVSXKdjz7PqPeovcaotAr+HtasM7rmKgq4x+y8S4WeW+W1TwFgouM5jJgkfugz734lszQ/ybb7jhD+VsBW/PW2hhFIA0fqw6MI843Kr9qNoQ68Ulu844ts9M/SFfAlsXeGmaIgJq61aK/0x0hOiDlIGMnBezcxAxlbELMOGQqPKc264nyLtVs8ilLLmzAWX0YTiM0ddfXshpriZg3mgmgUY7g+jxxkTPw2kuv9BgyiiTaVQmLpulkjrFqjMAPSv1g5Y5O7Nyb5VqzVwZblSZs9wwLk+DFFE1rxp2ilgHUQHnIj/sBVNFEtTkA8Z34o5P/850m0oRFACt8krnU0fyj3IQkU5ZQwvU6DpgiJK0UOQRdNK2+rd/EYrbgrNF2rgknQCVwEOMszMhHAVDaYhTAhBG2GlAcYtXFJwHNTfWLvVmTloXxio1oesDt5gbg7H1II6k7ymMexdcJ9xvk0RJ1CUfgrY4g9EpeiKGA/Li/2U31LrZQWfUepQyekGm+OQs7EGb7oTyFbVzBSr7tSpHDcxQhOpVdjyTgXNdyiBvKWaGQpjZUcAfMHvURnCNNcaNZXCdNLgjS7kuFn/lpX/Pqq1rrkG3Qs+ZBGAjwyUBVJJBshAJn2w1AY2HzT9pAobitJMgFK5qE0M62ORXrm50Q/t61nL3+i7JD6kuM4CA5H6yDXi+mPcDhBfFQUhDKo55yt6otVTL6b+8ZCR3J7Sw288EC6S8kZFrhMZAYylMiaMvsDeECOkHEyljGoYR9RICm1il5juLU+P8NiP78tg40fAL6a1ly5RjJnQuhQAPrDdS+kfcOvEUj+kFRIPMNa6Mudw7b8G8LGe9lJoCGrsJnGCgS86oUpYlUyOrUKse2kfktt
 BZCopYLI
 W4wNGJno0dE93i8GeuVHZjApYdZYppGmP+9hzntZ7tdJuBnxKXASTaICgrgXjm9erTBlUpbTbwWeYgkunxbak7OQMYgRfzv/mYpo/meILLGgLjS2FAbheY6W78AahY6hO8ulnUAyBUX94GEy/qibgo4aZXflZ/i/NGpSWDK22zoP9ENLg5jj04pQZGk7JELMOwAroQ0I2vywgCyb+fg0/A2mXUb2iI8tBxNkgtGAnaiwzRDi8CI0qdIt6GmS8tm7iin1uf2YOeqfbjpYlp3u+Cgzs3xxUuUIyiqbxaTDI5+T5XQTE4aZWkAk297ugMW2ttl6PmMPRB8ek48KqH+sRFkCOXTrsnYl2vDmOdVRuFt916lpc6Gq6LzEywRRdoXJpL9RPqF+M+MpoEQN67c0OHMU8vZjxl+tI29X/YDjnsJbVLqKeB6myHB9y8J16AMPWSdhkGfDzhMMT9vEDl+Wn5a4JNibx0GQw2m35SmHJNwUqrcddVl4WLLhkyMdI6oOUJJJxA7GxwUMghRSlIo2YDVeoE/URuTu8aUhzFneOl1tePG0q5MQK+df4xwvuN+Em79cnt2eKW4/Z9nMT09hDoq8DdhIPwmqdDo4DXMnSUJtWYRJs/zWyoMsPDMMYkWricPiwppOioHNolruLvE4PoH/eRa6RzVpINnowSZJwlTsp2/LLRDktBKFh8auHjh2hkXzv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Rely on the fd exit path machinery.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-work-fd-re=
serve-unify-folded-v1-0-4d5217d6b246@kernel.org?part=3D35


