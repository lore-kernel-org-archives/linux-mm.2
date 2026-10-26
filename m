Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C72EA606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm1 header.b=H2YNFYcQ;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=bK5U8HpM
Received: by kanga.kvack.org (Postfix)
	id 93D686B05B3; Sun, 25 Oct 2026 22:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914A56B05B5; Sun, 25 Oct 2026 22:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A466B05B6; Sun, 25 Oct 2026 22:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 474556B05B3
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:03:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F275C05FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:03:41 +0000 (UTC)
X-FDA: 85363131042.06.CEF0952
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C7C9100006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:03:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=H2YNFYcQ;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b K5U8Hp";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf14.hostedemail.com: domain of raven@themaw.net designates 202.12.124.159 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792980219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ObCoBFjUZfVpU7QAF/pPsY9nZQ/6rTEZ2XBtFy2tQpo=;
	b=55Pwm/l4z/Ar+x5JQgT+fdULnBFRV2GsHMLjzOx618rEg1YCJwxE9+JzbhX0NDiIUYmZhA
	rH8oIdQ/1valrUqjEcf7m2eA8uVDMyZ7850wV+/w0eH9imz4IxcNQhMBPc53lnmXwWBOd0
	igrTHnVZaIyuff0GvrLTd/k7qjIk4NU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=H2YNFYcQ;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b K5U8Hp";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf14.hostedemail.com: domain of raven@themaw.net designates 202.12.124.159 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792980219;
	b=dIg4ILOn72xggU4DNqb3yPm5UB973irnruB+Oe3WcWYu+gy1ujYDQnHlH6lLsTA+mY6sZH
	gH+O2DUQr7Uv73bsAZGZjnoxVKW8iojR/fvF/i80D4UK1LeVQ27uFGiTYIAvgo95us8/Zq
	A7XgXtlihn3VRwcpkDAEBpqRZV0XLaQ=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 826127A02D6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:03:38 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Sun, 25 Oct 2026 22:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792980216;
	 x=1793066616; bh=ObCoBFjUZfVpU7QAF/pPsY9nZQ/6rTEZ2XBtFy2tQpo=; b=
	H2YNFYcQI1nDWTbaulTrTpELKcaEwTiafytqufiM1FvVYpvM4fK/qSm6+46p2LP1
	GNqdN6i6i7rwvlyJHe50II3FXCZd5t/Qoen/xdb9n+kRt1nuST9+nsGCBzOGgemr
	PWK8NKArTFAJziSuCkVdKcxjQ0oFikS7jJ9mJ9dBU4lktr6U/ATjh4IcREDuddIZ
	1Jlp3huKz5LX7LBFy38/qODwuJLRrgjQV60COjWDKDzFzI7cB/15Y60ad32fI2/K
	9e9SwZpVRAOaxMwtrEechNF+CA0cGrSwXFZlrY98IEsjNnKKW0oqo24Z/kh+j96x
	YVu7/sVT/lgTaCOeyykmiA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792980216; x=
	1793066616; bh=ObCoBFjUZfVpU7QAF/pPsY9nZQ/6rTEZ2XBtFy2tQpo=; b=b
	K5U8HpMJ9Fe/6la/5+dqUA2AIygKEVUnOq7QareG935kQa73cYWP4mN8P8aCvhXj
	gyPl8reWEEf5tNLQydIkO/ANQ+PIT/TESYKkvvsy4It3RhvpdhZWzgdAZ6PAlBbE
	bubJuOi4OBqRlAZuOK6y+KF4EeRp5MZHEMpVGqHyZu/EiYkhZnfvlrmkZU0+g/Vh
	YjPcw+UtEa8jfuUbS5eCiQjmJ5CE2shM9zNC0qY/AYPzC4YtAAEsrCIRxWR4d5t/
	MPbhszeuWKy7wfAROCtC9N4bEGikTAt66FsaEx3WjHZqB8lkJgfDcUxIkcF6NGVN
	9jHy0k9E9w2cnKhQVXH1g==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792980216; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:B0PIXwTgYrPy/YMIlayQ0J89pang+kd3NniV+eujqgrf8Rh
	P1Ve20oIAmKsw1s/mt2fUXNoioD67iQSsqxv0VjCLOr4JgNSc4/jQkkxfPjCBWOY
	N7ekPWifkghuu+k30SpjthUUCwj4zWMYsYassIwtMF1ZHUftpQkzXhTfjFZiWTPo
	TlpMNoCmf47e2yNHo0AyRufbNVJJM0A7E7K4xMepsUp0U3EuacgsMr99K1U+3asa
	BFGZhY6o7fp2/UeR2f2IIQIUUwSr3lEAtYFjXL1nuCZuXqxy+PmM+W6DsBgu9gxv
	ZhWQm7ubmcfBKLzf7tpa0GK3WN6TfxPfpBdjcXg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:IBLuiHgrXhxkQ3yJpPBNgevu/+0GI+2p5QzfA/1lYvc=:ObCoBFjUZfVpU7QAF/pPsY9nZQ/6rTEZ2XBtFy2tQpo=;
X-ME-Sender: <xms:97TeajF9EMB84EGCCE7pRLZlMbXh8yaOJOK5hoUuhAkn1eRSTn1nTw>
    <xme:97TeanSxjpMDX7ZKdp74dorV0LYGyIOQ86GnFIqnn4g8aVOX4H1UdlO1Py9uVMld2
    WVWGNeVZAjdDRVaPbWY1DLZGpD89uJjli35AiDvVIjTt9mW0Q>
X-ME-Received: <xmr:97TeaqMYD-iB3j9b2YWLmYWw6OiB4t7hg-PRs84RTxXi1zmScnIoSatOQrOV84ymuKmNchiBxKXfj5Vz0pFQha6dVbwBRKZnVHfcV0zU_0ndIetGiAoOIc_wLr8>
X-ME-Proxy-Cause: dmFkZTGNejTxx4aqqfXZftYpM1visYrWvDsIt/Tj4xDAh9ziwy936SqVQXZVb6mtsHj8my
    2x+BJM3nCNAUPJwHTQds4VrmV9EdcH8LFJl8UDwDEOHPlekFXeIeMRhlTdtzymZV8nRIpE
    eRzO2ly9KiGOPmjn+i1mUMEFrRO1uS5KIXrJVckgeJeMGMoss/9q124Y/YBjRW0YQxFBKF
    gnhGRTa3nOzFWp2A4PhNV2WnEF9Rpa8a00pOi9TkxMX6fBOyVqTkBTa7yVDUpf7A3BbiGp
    jtTHyebMjuxSFERqGSCc4JCisM6sx3sfOM49mnn9h8kMAdYIqfGLAG2I+YNp88oH31Phmj
    z71IIo2DDHlUdwCrtAO99/AUBxb8nRPq1SuPVYQ3h5AwUZmcGh4XjABFlZ2pfMPFx9RxGl
    F41HO6KJXh54nFoL8nSrYjE5Ev/e7zicgMePlCL1HitKun6VAFur9qRW6LrFM7NbtXdarW
    RCSmKveXKWnJTkJWkagg/ZQTp1Q2cEFy2aDgBR+wy/q4C7jVwUbOyD5CGXqKmE98vq3zwr
    iZVauML6pJorRKtZ98haRD+S5NmMwTezrKY6EcR9SYIEl3O8vTAY2zLmaJOKhaUMaLQC9G
    1jsbxqOY3I2M7+qBcXcgQw6t2doc9z9F40D8GpbTLGc8Eeat3Bywn2zIW6nw
X-ME-Proxy: <xmx:97TeaoMnipO--jWtgECBuOHvtFXftegazaXXawrHutpNJlNUgj6Tbw>
    <xmx:97TeakF5dRLABBYUu9alJznfCgc_ba27mOfr57OkqyIObV5d_Y8f7g>
    <xmx:97TeaiPesgn2ifpl1BAi9bVMvs94JAeLRDLOO1eWfLI5WXKHo9p8Kg>
    <xmx:97TeamtPTCrlvbwTmKBsdgcSUd8qs965PQjTxySL7xlRoispdmaYRQ>
    <xmx:-LTeaqcRWG7KNgKcZLLnn7hMLfVf_MNWtz49jeD0YgY-TCX0lxqijeoa>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 25 Oct 2026 22:03:29 -0400 (EDT)
Message-ID: <2e2964b9e6bde6f263000f2a29e548b4f44b11a1.camel@themaw.net>
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
From: Ian Kent <raven@themaw.net>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>, Tejun Heo
 <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"	
 <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra	
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jens
 Axboe	 <axboe@kernel.dk>, driver-core@lists.linux.dev,
 autofs@vger.kernel.org, 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Date: Mon, 26 Oct 2026 10:03:26 +0800
In-Reply-To: <7a212208-74f2-4d79-8ca2-a1502d0e0a1c@gmail.com>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
	 <cover.1792577179.git.krystianmkaniewski@gmail.com>
	 <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
	 <22d41f2a5546d3bc90a1b3ad24ed3656588a854f.camel@themaw.net>
	 <7a212208-74f2-4d79-8ca2-a1502d0e0a1c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C7C9100006
X-Stat-Signature: p5hscet1cttcq1x6suaq46aeau4pr8sw
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792980219-122160
X-HE-Meta: U2FsdGVkX1+7uQBFsCbCNBheLmva6kHnaWLK4euJ8AT6me4tAx+kW19Y/SJLLLXFjO8AqCO8+scTfIVHJKT959h+kMs87uSPYP9T7cKZYfy8qSXQPZZPX8vErQ1JWKh5tOPPRET4eezeM+ITjU1BM9sY9LMrWNf2qJF7BPWF2zLFqTN1Ct+35gBNrnNFGbBzCo0LCefegRum9/zM5k+goyjwEvKmU1yxRlV2RDoRE9flImBeYYQNU8wF6OBafs1x/xUHFHP5EHi0NomqpqJLpHrmWZkBGhIJLzrB7jrsqHQ13pzvopnnsnzBtOM/vtCdf8+d0/91TLktppssowddL99rvd+E01GmB2rkUox+OoLATqwLHv80PMib4mbBMgYomhR1J5TIh/plyH9JjRF7jsG4otmIABf654rdFEVvjNHFKT4VR+//UYBvvrZt1siFN/si6pYFaGIO1z65mYg+9rG1mq6RrPuTDZWmJsWNrqbBF15dgTESwx0jt6CFz525dAB8ygDtcW7mifkNaC2NI/DQLh2CaoE7rxw2yco0FJsAyTATdYBECK1nvywgyl/MbtpRRBfRCAZX4pCGrFRd52ZJwIQaBqyiro6Ayf73FYkdmnFen+CzWjyuCQ0qKrraV0um5FlYEuCyTBm1do2HmA3N01Q05DR+Yhz809LQjVCD6wCqO3rQpZMoJ4JAcB+qOwazGmC6xQm6TxLYuZook3gcTINp/NArTfIb6RI7LWiZmlUvue9bL7ep1OQukMnF54KIZP23JzBh9LRoiZTTBnBcVx0vtpbE8pX9Mc9xq7igrlSm2FUKU3EUiQbh+OzyIjhh4WBUtlALjAR66fg+9lBwb6Yj7CLegSF6oCaDq/wFK5x1VVx9Ubhyj+stgSKqn35KUsF1bEkHWSyeHp+azF2OQTTjjl09dtJd7wVJWkpdBkgcHbPFgH4/d37Vo2Q4h1U0PoVv6iLw2Wpxcta
 7M1XmFsP
 rQ3hxB0r0ZUlgwteuU/jIwO1GzQSUWxWFDXEmqUqXAjFD3KzxA6OJBmAhqbYvn1G8uYHHomf46fxgw6NyPehAfhUELoolN7Fb+ymzqcoKK3XLV9MdrFvlINa0gxZTGfGzR9DhEvGr5XEZDOAVuhAqDMLfNSrx+L0g4Uc/LXDKeX68cRh4lhGBeFe9CgYgrUt/kj92ZCgq9mOpnM8VFrWolN00IodcM10hq13QnkMBCSiOhIXDpO+x0tLqYnSBC3yf4lM2hwK6o5ANRfSv1LwvNjzXXu3f09IpJC8XLbjpipvtxacUdSVsfc3qfwMrHHvnCNHiLunqmCybS1Bh90xR7RYF62Nd2RcgM+qYubJzARnYS1r0kVS7e6hHLDDyEvkZe6zWYbRW3APeL0HG5mDwJlfVcK4ByB4Q8NOOR9lcLrc/E7zmIaPcXEgP05ry9C+/+xzjVUV/2wnK1Z/pAsRdF8T77yucjbf1j4slrHKabhXHxW9NcvdXMcgAVyi3J7PLM6dxxyMdWId7Sk/z+9TxYyxvXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 2026-10-23 at 16:05 +0200, Krystian Kaniewski wrote:
> Hi Tejun, Ian,
>=20
> On 10/22/26 04:46, Ian Kent wrote:
> > On Wed, 2026-10-21 at 11:48 -1000, Tejun Heo wrote:
> > > it doesn't make sense to change the locking scheme for it.
> > > Can we just disallow splice on /sys/power/resume instead?
>=20
> That would address the direct case, but it would not make this report
> go away. The lockdep report combines two separate operations.
>=20
> First, the reproducer splices a pipe into the cgroup v1 devices.deny
> file. This records:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &pipe->mutex -> &of->mutex
>=20
> It later uses a normal write() to /sys/power/resume. That records:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &of->mutex -> &sbi->pipe_mutex=
 -> &pipe->mutex
>=20
> There is no splice into /sys/power/resume in the reported sequence.
> Disabling splice on that file would prevent some direct deadlock
> cases, but the first edge of this report would still come from
> devices.deny.
>=20
> A complete restriction for this attribute would also have to cover
> both splice directions. With an O_RDWR open, a splice read takes the
> output pipe mutex before the same of->mutex. Another thread can write
> through the same open and reach autofs in the opposite order.
>=20
> Kernfs splice support is established behavior. Commit f2d6c2708bd8
> ("kernfs: wire up ->splice_read and ->splice_write") explicitly
> restored it in v5.11 after the VFS stopped providing the implicit
> fallback. The pipe has been locked across ->write_iter() since 2014.
>=20
> I agree that changing serialization for every regular sysfs store is
> too broad for this case. Before preparing a v2, I would like to
> clarify the intended scope.
>=20
> > Not only is the description hard to follow the example is flawed
>=20
> You are right that the cover letter was hard to follow. I should have
> described the two operations separately. The automount itself uses
> the
> normal empty directory case.
>=20
> The reproducer creates a detached indirect autofs mount with its own
> daemon pipe. It changes its current directory to the root of that
> mount and moves out of the daemon process group. It then writes the
> relative name "0x0000000004000921" to /sys/power/resume.

I still don't quite get the scenario.

Maybe it's just because I (still) don't understand how autofs
is implicated.

By definition an indirect mount is an autofs file system that
triggers mounts in the root directory of the autofs mount and
those entries must be empty directories. So I don't get how
accessing /sys/power/resume can result in triggering an automount.
At least that's how it reads to me from my admittedly autofs
centric POV.

If there is something missing from autofs that could be used to
prevent this scenario then I'd be happy to implement that.

The above paragraph reads like the autofs file system needs to
check request paths are within the autofs file system but that
doesn't make sense either because that that would mean there's
an autofs mount on /sys/power. But it is stated below there
isn't an autofs mount within kernfs so rejecting autofs file
system mounts within kernfs won't help.

Note that an autofs direct mount might be susceptible to this
as well.

>=20
> resume_store() calls lookup_bdev() on that string before trying to
> parse it as a device number. The pathname lookup therefore starts in
> the autofs root. The new negative name triggers the normal mount
> request for an empty indirect autofs directory.
>=20
> The dentry whose ->d_automount callback runs belongs to autofs, not
> to sysfs. There is no autofs mount on top of kernfs in this
> reproducer. Kernfs is involved only because resume_store() starts the
> pathname lookup.

I'm sorry, there's just not enough path information to work out if
there's something going on that should be checked for and rejected.

>=20
> The change which made this path possible is 1e8c813b083c ("PM:
> hibernate: don't use early_lookup_bdev in resume_store"). It replaced
> early_lookup_bdev() with the normal pathname lookup in v6.5. That is
> what made autofs reachable from resume_store().
>=20
> > The other possibility I was thinking about when I saw that report
> > is to disallow file systems that don't make sense for automount.
>=20
> I may be misunderstanding this suggestion. In this reproducer, the
> filesystem which owns the automount dentry is autofs. A restriction
> based on the filesystem owning that dentry would therefore see
> autofs,
> not kernfs.

As I say, it sounds like, the only valid indirect mount request
must be triggered by a sub-directory of /sys/power which is a
mountpoint within kernfs (or maybe we are talking sysfs) which
could be rejected in the autofs mount code.

But it's not straight forward to be sure about which file systems
should not allow auto-mounting but is probably doable. For example,
systemd (direct) mounts /proc/sys/fs/binfmt_misc but mostly proc
should not allow auto-mounting.

>=20
> The lookup from a sysfs store is also not unique to
> /sys/power/resume. For example, with CONFIG_BCACHE=3Dy,
> sys/fs/bcache/register also resolves a user supplied pathname.
>=20
> The exact reproducer records the lockdep edges with different pipes
> and different open files. It does not deadlock on those mutex
> instances. After sending the request, it waits killably for a daemon
> reply that never arrives. Related setups can deadlock when the daemon
> pipe itself participates in splice or tee.

I think this is what's causing me trouble.

Such a request should never be sent over the pipe, there should
be validity checks in autofs to prevent it. Unfortunately I'm
not sure about the path info.

Ian
>=20
> Given these two separate paths, did you intend to prevent only direct
> splice operations on /sys/power/resume even though the reported class
> cycle would remain, or should a replacement also eliminate the
> lockdep report?
>=20
> A per-attribute splice restriction alone cannot do both. If this does
> not justify new kernfs infrastructure, I can leave it alone.
>=20
> Thanks,

