Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78617C531CF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 13:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33EA36B008A; Thu, 23 Jul 2026 09:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EF996B008C; Thu, 23 Jul 2026 09:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205B76B0092; Thu, 23 Jul 2026 09:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF2F6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E7A714049F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:29:45 +0000 (UTC)
X-FDA: 85020123930.26.548BC8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 991052000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:29:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O344mY24;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784813383;
	b=g4dK9W2E2+L02YfqVLUfWfN8U3k2HDmA+soM4ftBZ/e3UKV+0kKTfZ50qm51biUYGBqPA5
	25uwg6mSsBpEOiK2w/p4AbKvCNaMEEOZllloz/63iCF6VRaaG1mz3fNrHW8uZxHSLhsofJ
	nFQCt8HqD12fcUZivMaZXrhNk/YvhGI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O344mY24;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784813383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/eJaksA8cVR2h2DWYNLQWK0/asNQiai/rebHD8qgg1s=;
	b=dHv4EJnT61kFSnHk1MyRO410E1lawTlEcy1i4jS+vzu1ASMgye3ccYWmzaes3V7E5aTFA8
	CVJjRMRNqyDeWucx1Y/hHnB6AkTDQpgLSvGuu1lyowXKcPHUoK1WJJ61waPEzYjW8ZeYMA
	2WNTkgNRMVhs48pP2NEHJQOxRrgQMzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09752600AD;
	Thu, 23 Jul 2026 13:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2981F000E9;
	Thu, 23 Jul 2026 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784813382;
	bh=/eJaksA8cVR2h2DWYNLQWK0/asNQiai/rebHD8qgg1s=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=O344mY24di77hY1DpoQTGBaL/uH0bJpdD7FKCI+mrUNk5Z/tPe856FQFGZv5jHEo2
	 YZrPy38475ITtvSH9z7qFZHirUWRYzIvK+R1DvxD+ttwMVs7K3jL86l2TMuM+C+/MX
	 abg/gN9vXhAV03N8eiV3vl9QtPAw57YMniITd1xsqAfSYgqKsNzyUh0BD3eXHF7Cv0
	 FJz/82jygREDLtA75V1NGDD5GGF6MvxxyZ2jqQmRdyVZFOJUKVrAM6frEHeVf7WQ6f
	 MsXHyBReFNy8ZaoJ9NwRXYhf0h6C98p1jzLU4gzMA6/2Rh88OiiKS21Gi+i0MxLN3z
	 v9odJn6VK0Rig==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] binfmt_elf_fdpic: only honour the first PT_INTERP
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, stable@vger.kernel.org
In-Reply-To: <202607222110.D5AB43796@keescook>
References: <20260721-gezittert-medium-kreide-b41fc1f0277e@brauner>
 <202607222110.D5AB43796@keescook>
Date: Thu, 23 Jul 2026 15:29:36 +0200
Message-Id: <20260723-ertrinken-ahnung-pizza-5aac875268d0@brauner>
X-Mailer: b4 0.16-dev-0e65f
X-Developer-Signature: v=1; a=openpgp-sha256; l=1076; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jlS1CQ2CImc0/y+01v6Hb1rpC0YyyEIywGqsUrLzmb4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQliTtd+ryyUa5mVdSS0JZpdlPsDbN+6byVj5N8uGN2S
 OGpU7e1O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayJpaR4d780AUGn2QcPxed
 72IoDGF79Zy7YNGzXpkTtwVzvl23uc/IcCqSU/X6pZ0KN8WTK2Z/Xrf/chb3hknzYi+Y8e7PUkh
 dyAIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 991052000D
X-Stat-Signature: 4sda5bausnzd5c73xmbtsyfy8gwa8f34
X-Rspam-User: 
X-HE-Tag: 1784813383-185158
X-HE-Meta: U2FsdGVkX19ScF7JEVC8UUGNjh18kGkF5Fjd2ewXRxjBozrz6ypWoFktTqKFVJe3KMyP6WLp1LH/pzOBWbD0OU/1TDJjrBiDz20KPG+nNdrZPCGHNOOIBnQf4r5n3Hc2Kx7apRcCPp0ruuamVep6IPrUtA4V1VsSPEQVB1nibaTlhIFgwps6I1yual0pCZzUMerQTC7YTWvH4D9O+nWRUwpm6LF3HmfwDC1/ynsGwjUPW/8Why9Od7RyKzDcB83LnRUoUOXPceQNwbTLvbjmik316HvLfB2RarGnxpJdMd5WgSrv9TVg9sGPz3XZn6wxHz5HSz+olYCvwwgB4hYggyoWga5HWtnBj71B2qaQmuzR4tEFpBM85zY4hLW7gOO4NkzVu098dnqBN3fcKKcfNFed4vSrvzU4v58HJZtoALt3Ncf+S2khMP5csoo3WamMZm+uJ6dTyF5cgfTKzOfByYzogDnV96/tk99uRm3CrBECgYPKE1Sg6Pm+WJKv3x5ouomu4cLtrBspAFUWnEewf3/gLbxMzxgsP+epBskGs+xCZRRByLFbsA9SzRkM3LFEThjJ0MIIUWe7NEEMyYRcPExZm4qhaPbALEd2LxLDF9pl7RdZVrVpR1MbtVi5x/+DxKlv5vfbfdFF0WZ2Or8iDNH8QF59BLT/vuU/KtzqGddoGrE74YW+VXS73uIxJWdd8QllaoMWIfUgBmBrkFWh8xWj2Zj8v57/qz6+kcIKV97wqLJDX9inKkkdHi/wWZ4m1k2vkQlH3OTDKeCe6k32IIQIYqntc4hmSqOuf90Q2jfjGakhTRRD+ri6D4urAIShP8TawCD3xxyyVBkpAGoM5r6Q+8uTbWbY2zT4kqRq3ntDQwJ5+SS4ArZnjSXlE+bwsdozPnHGAi+aF4xGrpyNGqBbaC/kfaQ0E0977wmEGFuu3Xi0TRZx6CcCXSzs0gdMT9+aLmxnEDO8u0VXSsb
 /TGsvLlC
 M55G4yE2tPzbD9s7LjZCjo7sFUT8Q7hNYaMsl5sbgYt5WCpeyIfo8eXwWSlNmMtt5lUsmEwHQnVbbIbPWDYSU7zdb4Oxi6FA55425l2XTGaKDUpRJynAoQ/l2rlwy1xB8GuLHT35y8TbfCI5eogEDcB+b4YzJHceij6jfiDz0oAVebyq+eT7tnudBJLoRHeN24zVDQN1Dp4cvn+caXuYd3Dau7eJuvO2zXZgABoJ6VjljIUWzkxyo4TBS9KX/V0iS+FtDv3lZ81Ds7Y4qRC1BnpuAZVZkNuVTAoKE1bQu2A5t9CZUa92ZM43P6qMvdLnbnG/d0AXrXWN7z369Q4hmmmjIwyQquYKnNV8SHr0AOh6ZghRCzQpstOFaNBZNpQ/UnFe57XTkUebEUA690NFQodeeXldsnqH/DRLG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-22 21:13 -0700, Kees Cook wrote:
> On Tue, Jul 21, 2026 at 01:20:45PM +0200, Christian Brauner wrote:
> > The program header scan handles PT_INTERP from a switch nested in the
> > scan loop, so its break leaves the switch and not the loop. A binary
> > carrying more than one PT_INTERP runs the case again and overwrites both
> > interpreter_name and interpreter. The previous name allocation leaks and
> > so does the previous interpreter reference, along with the write denial
> > open_exec() took on it. The denial is never released, so the file stays
> > unwritable for as long as the system runs.
> > 
> > An unprivileged caller reaches this with a crafted binary and repeats it
> > at will. binfmt_elf stops at the first PT_INTERP. Do the same here.
> 
> binfmt_elf ignores all the other PT_INTERPs, which is what you've done
> here too, but I wonder if it might be reasonable to refuse to load such
> a binary?

As a follow-up change I think it might make sense to try to do that for
both going forward. As an actual fix this seems safer.


