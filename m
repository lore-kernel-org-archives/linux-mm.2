Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D5A606A69B
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O90bpdZJ
Received: by kanga.kvack.org (Postfix)
	id 3D8BA6B05B0; Sat, 28 Nov 2026 04:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3624C6B05B1; Sat, 28 Nov 2026 04:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B3F6B05B2; Sat, 28 Nov 2026 04:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0E6C6B05B0
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:53:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A179AC0584
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:53:09 +0000 (UTC)
X-FDA: 85484064498.23.F120664
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D501940004
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:53:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O90bpdZJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795859588;
	b=xanXE2fwEy4jRuf/JN8J3/s3A6mmenLrm+lOYMCTiC4AFUbzcGLS5Ea/UysqmRe3s+DTWB
	zMKckk5FNMrSw9kVlBnmagQCwCoAjsxE+mj4hYt64r3L/fE//3gKP5hW7jzhEGqSTBMDUq
	H0VkxZ+f0yZXHI7rlLB39W6fqS2GCa8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795859588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uuCJfxu+5v/s3T9HZYDDO4PQ78T7+CAZAP1vnBBAvlk=;
	b=GUkhMC4dUZTjCocqFQSOG7sZQgz6phiAv4ZMsGOyBsvuPW85BByOlak1vF/VCWL1l2mNak
	R3HOHbzMFCrNjXXJA9iuuwEpDHWhPy9MM9SDpPUmW16X9Hu6hCwH0BCGkXajL5aMt0YX0b
	VPrN0LV76BSiF5rNtzXM1Ft15rg87mA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O90bpdZJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id AC0FA409D7;
	Sat, 28 Nov 2026 09:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6485B1F00898;
	Sat, 28 Nov 2026 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795859586;
	bh=uuCJfxu+5v/s3T9HZYDDO4PQ78T7+CAZAP1vnBBAvlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O90bpdZJYUF4YtVEHRhxLIqAQcGy50tt88f4anF0VE/73UpKeNhLHD68p2I+WORMK
	 rah82jxUIvM05z0HQJ/7Gqht46duwVcWBAA4Oly/9mfXmO+FtP3AerdVZuhwSDsTND
	 qM0CwtmBy7HUavbGOi/u6v2oO6ryFERhYnwndigZHNCMKVkkArcGDjH2cQyn7u/Yxo
	 ch06xXxQT+3tv/6rc/cH79zuTzT4aXGnW4UDzq/DNhpOjsNAQ3DeH1WZiEw6CYGr70
	 9+Za9L+aD1Tujgq7wvwmbeuoir2+LQrCzVjdS4n48dDUNG4J7VG+DZVSNmaxFXrDCA
	 BIidWv+0lMYcA==
Date: Sat, 28 Nov 2026 11:53:02 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awqkft-e6Tbj7dbJ@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
 <awoHex4LVst2JwkO@kernel.org>
 <awoO9R7YF_5_6dHA@kernel.org>
 <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPnZJGBnFyrmr88OsYkMwtLiR93z4g0NAuoMurcnhcYFXz51jg@mail.gmail.com>
X-Rspam-User:
X-Stat-Signature: 83im1nsabzkqetjit7p89f6t5rqfdw7s
X-Rspamd-Queue-Id: D501940004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795859587-686306
X-HE-Meta: U2FsdGVkX1/KOk1Aw8hVuf4RF5Kiii02pOblO/zYB4kwUsRJtQaQt5IgLDVoOdtqWsqJu9U5sLAINrhPSOUdMLzsfzO/FzoV1h88+qVRVNjSM/0QUqs3IN4qVSUBDVwyB3O5j0FAOOnNPXSVVcl/JY88uNnQQ3vE9HYplsMtx3gBKMAHv4PVDejrpi3fnEzhezPNmPKHMh+lCuKOpo/xtP1bfcmeDrO4hiLtTDuN0Zks6TwQaQpOpuHxjgKyVaSFcwB8/mIvdISef/GwS6HPjNicqoJ0/2cymzwfQR99mrdLf//y0BZBX0w9mC7Z31mOc5Zb8/9y4z2Godj9ihCE12jOuHYEiUdV5WdnYFfLGxvSgD8DDzxjjyS0n/r66G+OTvERg2gfjgC56wvCfhAbJaI7Q77ThUaMbbBLMd8Q0dztpSa0o5KcRgkNtBvhEKRZ72lSubH16CSM32sI3/13oMtVCP7HTnc4QDn/mOL+sKH6TOv1DRlAY65s8SN7PLkbUwB+hTs27P7rlQZh2YvS84dB4z7dg1Fq5lSLk4RSHKttweu49CoZJGsUS7bnEKgd10uEHl2TpnCOxj2fMrazHmb2+/GlDKZjoX+uUD/ITgueQpU7i0TmKHgURDr/eItXE73tpFfe3Cu+m7PtNbMK6ccsOOd0vTnRZCJ4X6J5W9YU0/Vpug6lJZdL/zEVokV7Y4obEX+e5c7KedJIsPAQCFEAUE3ixgn878E1QcBJMKxkodzpsVri92MZ8Gq+BhQ4xPKAFVa1z+J7UqImh6Cr3TkGjHpM49Lu2B/KLuvYWp+sEb9Mhi1lICggZqeXJAGV7mNyCxJlvCBnRSiIXCWhACvLHAA5/U7xnpzDUGdgcDZ0g27/taQh5w/5W2kBiCOEcdiiianXIH0jfBTK60weNJsJLWTJDL3J+B//Xcdt7Zk3CvwsR2UvXobTvuJjz/rBySC3nOveGp8mrOorjpZ
 GMjG8y8A
 UJiy2gjkXNNdWB7fU+UmU9VXthphHpTl2ExWpevP4rzWndBzhXZygd/D8ssmueFbhRYGYtKvUwmWZsdhLWOXVt8gsLBcR1BWI3sr3afdkzMnRP2AECJd0RDU6uGTSjXnl71a3gZRR8NVcKil3o7VQxZE/Goz5r6RYLm0Sg5mBVX8ADRA2Fs/HtXox86mHYx5mBc6uEHlMBW9HHnvYNzseO6vlXcDBung9pG+2uMIW6MBe2RDW4JuXC9XK37TfBiFJXlolVWqWIif/7iqApeEJy6MqVbOwgB4Bk3IiqQQ5RDoCbfnRbk3gdH+Qm67xG5++J09VGpAZl98/NiTXwG2H6Q8OSOdjuhjIgDR6nLKrAyqb+iXWyL+fR2utP8SQ21c/sBB4Q7K/FAeSXTb3kXbqG4843/+jBSz/Z7v+YABz9G2XbnyMDPrVnvik8KbgsftUrAAtDXQHkFLJlzVbYY9hLVBXs3V4LaS8GSxq+BqGjMHXNK8SDf6g5jKK1ZB0kBNcvrvVr5V0GnkmpsH9n6py/jpPC1p3xdLoujajxq+kNof3y6yo64L1gQ3AML/EXs15egvIH3Zox5FpHqAK/SN46JLgM3N7oGNcdtHxj/dAFZY10BHDoBy4YtY74ljyhZD4dlVVM+nWA+8YS8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 04:50:42AM +0300, Askar Safin wrote:
> On Sat, Nov 28, 2026 at 2:15 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > thinking more sequencing than data structures. I.e. I have a game where
> > I need to end up to process creation without embryonic state, and add
> > just enough weight to kernel to support that outcome, and that leads
> > to ~2K'ish LOC of extra kernel complexity.
> 
> So you don't have embryonic state? I don't like this.
> 
> Let's assume the following situation. Userland's PID 1 is already running.
> Our container manager attempts to spawn yet another process into userland.
> As well as I understand, it should do clone3 with CLONE_INTO_USERLAND,
> and then execve.
> This creates time hole when there is process, which already runs inside
> userland (i. e. its PID namespace and other namespaces), but runs
> container manager's binary and have container manager's mm.
> This invites for bugs. Other processes, which already run inside userland,
> may somehow take advantage of this.
> For example, see section "CVE-2019-5736 Is a Very Very Very Bad
> Privilege Escalation to Host Root"
> of https://brauner.io/2019/02/12/privileged-containers.html .
> So, here I like embryos.

We all have things that I like but let's talk about facts instead.

CVE-2019-5736 was also not a sibling process racing the pre-execve
window: it happened inside execve() itself via binfmt_script resolving
container-controlled #!/proc/self/exe.

CLONE_INTO_USERLAND rejects CLONE_VM, CLONE_FILES, CLONE_FS, and
CLONE_SIGHAND, keeps exec_state->user_ns in the caller's outer user
namespace, and resets exec_state->dumpable to suid_dumpable (0) when
installing userland->user_ns. Until execve(), ptrace_may_access() checks
CAP_SYS_PTRACE against the outer user_ns, so processes inside the
userland cannot ptrace the child or access /proc/<pid>/{exe,mem,fd}.


> 
> -- 
> Askar Safin

Br, Jarkko

