Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60ABB606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C7E6B05B0; Mon,  9 Nov 2026 07:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8044B6B05B5; Mon,  9 Nov 2026 07:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719DC6B05C0; Mon,  9 Nov 2026 07:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49C0A6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:19:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C03AA1204EC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:19:48 +0000 (UTC)
X-FDA: 85415486856.19.B8FF11A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3434620008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:19:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	spf=pass (imf03.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5JP4eF6mguHdDcK/HiEZCEolZOvhI3XY3/TZJENvHOY=;
	b=zONbNyhty3+yxhruRa1v+FZPn93myzX0mD1zX/YTlh6egNMzXQ7AvDVkn2kfntMeCAX6N5
	vFNSdkbWxNrqy6sF2dsIj/5zWJGGXhVLHBgbM3ZCd2cHU0LpBbnneGV4lpCZPmrC2QXX3O
	9DTr2TWQVJd56+uplwj3aRmmFvXtUbs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226786;
	b=PPzOmFFwNJKuFGYyEFFDqrOhnlYj42VPAg/GYcbwbHzALcdqLAOAORtBuy737i9ZI6YXnu
	498zsR6AJSrQWGZ7Didam16V3vtHCs9ryMyYhXHojCN7+HhK4Is1P63z4/BihU9tR/IryI
	n3E1EtIA+fKFmwUnxcwNdLn9+9DwqiI=
X-UUID: 14fa1962dc3711f19a56ed5b684f684d-20261109
X-CTIC-Tags:
	HR_ERR_NO_COLON, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI
	GTI_FG_IC, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a379fe88-ed4f-42f3-bda7-d60a1476168a,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:a379fe88-ed4f-42f3-bda7-d60a1476168a,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:b3a0003dcdb6d3612e3ec4920fd72aff,BulkI
	D:261010210608FCZ9WBJC,BulkQuantity:11,SF:10|38|64|66|78|80|81|82|83|102|1
	27|136|153|841|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL
	:1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR
	:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_OBB,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 14fa1962dc3711f19a56ed5b684f684d-20261109
X-User: duanchenghao@kylinos.cn
Received: from localhost [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 603396441; Mon, 09 Nov 2026 20:14:15 +0800
Date: Mon, 9 Nov 2026 20:14:12 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Luca Boccassi <luca.boccassi@gmail.com>, avagin@gmail.com,
	pasha.tatashin@soleen.com
Cc: jianghaoran@kylinos.cn, linux-mm@kvack.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, systemd-devel@lists.freedesktop.org,
	rppt@kernel.org
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed
 service
Message-ID: <20261109121412.GA1040902@chenghao-pc>
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
 <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
 <20261013110237.GA836401@chenghao-pc>
 <CAMw=ZnTksVT1wuQwAjzz_2tYSCvLSxeUBa3mYQvCFuKUtcydaA@mail.gmail.com>
 <20261021103633.GA1324331@chenghao-pc>
 <CAMw=ZnRpDdqKDPbofeF=1U70Q0Ms0aniwA6OPF-paNZEb+k5bQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Description: 
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMw=ZnRpDdqKDPbofeF=1U70Q0Ms0aniwA6OPF-paNZEb+k5bQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3434620008
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: p7ccgd4hmukkj13kk7168ndatfzr1anx
X-HE-Tag: 1794226784-440810
X-HE-Meta: U2FsdGVkX19OUXvr9MbTgOITHT2G6/mVmBeSt+s0aYWCqehicCjO9CajIgYR7EueCf7GflfQLsYBBer4U1a8KNyFmknVhWLmTTfIEE+PPAj+m8dzFVSRiiEFqlgZHujiCk/25Zy4s5LyVAK/VzAGLdf0I0NCuppJ341x6cfJiOzoJHYc+iDcoKF1ZliFImDvtMfgjEBApo4HUuDQNwml/hz2WPK3heB+XY+jlxx6JB20WtdSAJCEhnkI57ed2dAnhPiBy8FD12hK4u+89UkgYAhHYDHX6Oz8dG2bjNK3YCoDWWNHBgI7Fw0vDamxYWK0VNJUE1vACLNmtKmNXguu7v4afVQo7zng7jlFVaw1mKAHXo/3BEPYgNTYSlcQ1BBg94DPav/1I9RW1kUVZi3AZHhpc5oR8TC/TlhvIml6UptgydIsm1IH96GurIMj++Nfu635P4z7ldAbDmgAgi1HdDwLwSMrbyo4LLHmMQZXLI0u8fkZFOI3/wC4MVwrJhM8b7agJ7FMx5Ymmr2vXeaakdwsY5MiHIXUmDOlfAmqjNoWSdw3DYjDAlWy05K75+YYPxvMavs7WMdBcf7jW1Dpr+5TM4UxCK18e+oG//ht9R3r4YUFv3z6IZPZdwoc87UO/OXCpq7mMq61PnFOIapQhR1cDHgZRIe77G+RRU38osqrBuZsasQEli55Oj91IfI7PSCHaS816E4YP/h7E9HxQPxIJc3Jf+p9utmqutDBU4DdtIFvF0JneAcRw0NnhQ1bGR8FLPE3fARKfLkZ6ef6+csEoutdytQ+ggxZZ1OskJkh5uheklQdruYWAgIxSsYe35CzfLHBj+ctDGHsnnUWbZGkOBCo3FA6cKA/O9GWhfvgVDOkAJCnqAfwkqxOnIYfooEtDbFdaMvB4Qin2dNMwBr6UjoqLlOHmu5amuHa/W4uMvZeBBgwowpOxJxBMnaaQkN/S1uPkdOgvUZUw+b
 8L36OgQp
 4SWelG/6p0sbjtJtecHRo8BNw+0T1R3Ug8iBdJz2wFG5ylUZFxcD8w6NoYM3KoKxLFDffTmsUIEyiHH0LzLK+Em7cnzr0QeOC1RzzjTQh6xeYC3gaaQccbI2kUnAIxeKStG78qJRp4+EdRVH9M7qch/a1imO1IkSMzKt8klfiRAOoVCHfTBbPHSF0K2Z3716ClALfMjUvs78ot5halQa2EpyiZKr9CUod8RXB5/a9zyRzr6uIWSoW+hR+/lXkdxb3Uk+tHmOty05JbWcFRUA5Emb/IsxpsUmxDQ+rwwxWe1nxnq36wGtc3n5iFGrm3TrThebLAwP+WAUVpLxnSbF6N+Pv2FjW1cbWIzI5Whr8lSE9J/4DbvwX7kqB8LLhqa29AygbAinsnIrTV4uV2vVfyw53M6wWBCgaPZp3ykEaFlDJYDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:22:13PM +0000, Luca Boccassi wrote:
> On Wed, 21 Oct 2026 at 11:36, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> >
> > On Mon, Oct 19, 2026 at 01:13:28PM +0100, Luca Boccassi wrote:
> > > On Tue, 13 Oct 2026 at 12:02, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> > > >
> > > > On Sat, Oct 10, 2026 at 03:05:40PM +0200, Luca Boccassi wrote:
> > > > > On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> > > > > >
> > > > > > Hi Luca,
> > > > > >
> > > > > > I watched your excellent presentation from the LPC conference in Prague.
> > > > > >
> > > > > > I have a question I’d like to consult with you.
> > > > > >
> > > > > > I am currently working on the `memfd_luo` feature in CRIU. My goal is to
> > > > > > leverage the LUO capability to store checkpoint images inside memfds.
> > > > > > After a kexec reboot, the image data will be retrieved directly from
> > > > > > memory instead of from disk.
> > > > > >
> > > > > > Here is my pull request on the CRIU GitHub repository:
> > > > > > https://github.com/checkpoint-restore/criu/pull/3152
> > > > > >
> > > > > > In the PR discussion, avagin suggested using systemd as the CRIU daemon
> > > > > > to centrally manage LUO sessions and access to `/dev/liveupdate`. I have
> > > > > > watched your talk and read parts of the systemd source code.
> > > > > >
> > > > > > From my understanding, systemd currently provides a unit‑based solution
> > > > > > where child processes can inherit LUO session file descriptors. However,
> > > > > > this approach requires the target service to run as a child of a systemd
> > > > > > unit. As far as I know, CRIU does not run as a systemd‑managed service.
> > > > > >
> > > > > > So my question is: for services such as CRIU that are **not systemd‑managed
> > > > > > child services**, how can they obtain LUO‑session‑related file descriptors
> > > > > > managed by systemd?
> > > > > >
> > > > > > Thank you very much for reading this email. My knowledge of systemd is still
> > > > > > limited, so please feel free to correct me if I have misunderstood anything.
> > > > > >
> > > > > > Thanks & best regards,
> > > > > > Chenghao Duan <duanchenghao@kylinos.cn>
> > > > >
> > > > > Hi,
> > > > >
> > > > > At some point up in the stack, everything runs as a systemd unit, so
> > > > > it's only a question of figuring out in your setup how to pass the
> > > > > FD(s) up and down the stack.
> > > >
> > > > Hi Luca,
> > > >
> > > > Thanks for your reply.
> > > >
> > > > The `LUOSession=` configuration only takes effect for services managed
> > > > by the system manager. If I run the CRIU command from an SSH login shell
> > > > as I am doing now, the environment belongs to a transient unit under the
> > > > user manager. In this case, we cannot use `LUOSession=` to obtain the
> > > > LUO session fd via systemd. Does this mean the process needs to open
> > > > `/dev/liveupdate` by itself to create the session fd?
> > > >
> > > > Below is the attached service of the process found via `systemctl status`.
> > > >
> > > > [root@localhost criu]# ps -ef |grep criu
> > > > root       57589    7729  0 18:25 pts/2    00:00:00 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4
> > > > root       57784    7571  0 18:27 pts/0    00:00:00 grep --color=auto criu
> > > > [root@localhost criu]# systemctl status 57589
> > > > ● session-5.scope - Session 5 of User root
> > > >      Loaded: loaded (/run/systemd/transient/session-5.scope; transient)
> > > >   Transient: yes
> > > >      Active: active (running) since Tue 2026-10-13 10:03:55 CST; 8h ago
> > > >       Tasks: 4
> > > >      Memory: 148.9M (peak: 1.3G)
> > > >         CPU: 47.000s
> > > >      CGroup: /user.slice/user-0.slice/session-5.scope
> > > >              ├─ 7712 "sshd: root [priv]"
> > > >              ├─ 7724 "sshd: root@pts/2"
> > > >              ├─ 7729 -bash
> > > >              └─57589 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4
> > > >
> > > > I'm not sure whether my understanding is correct. Could you please
> > > > provide your feedback?
> > >
> > > That's a user unit, and as per the documentation LUOSession= is only
> > > supported for system units. So yes you have to provide your program
> > > with privileged access to the character device and create the session
> > > yourself, and then stash it in the FD Store as normal.
> > Hi Luca,
> >
> > Thanks for your clarification.
> > I now have a rough idea for the implementation: CRIU will leverage the
> > FD Store facility to deposit the memfd into systemd’s file descriptor
> > store. As FD Store is tied to a service unit, a criu.service is
> > required. The unit file I intend to use is shown below:
> >
> > [Service]
> > Type=oneshot
> > RemainAfterExit=yes
> > FileDescriptorStoreMax=10
> > FileDescriptorStorePreserve=yes
> > ExecStart=criu command
> >
> > Does this setup conform to the original design intent of systemd FD
> > Store and LUO? Please feel free to point out any mistakes.
> 
> That looks about right. If it's a user unit, also remember to enable
> fd store preservation on the user session via a drop-in, ie the
> user@.service system unit


Hi Everyone,

First of all, thanks Luca for your previous suggestions and for sharing
your thoughts on the systemd integration.

Following our previous discussion, I have continued investigating how
CRIU could integrate with systemd's LUO session management.

As discussed with Andrei in [CRIU PR #3152](https://github.com/checkpoint-restore/criu/pull/3152),
one of the main architectural challenges is that `/dev/liveupdate` has
exclusive access semantics. This raises the question of how LUO sessions
should be managed and how session FDs should be made available to CRIU.

Based on Luca's suggestion, my current understanding is that systemd
could act as the central manager of LUO sessions, while CRIU obtains
the corresponding session FD through systemd.

I think it would be valuable to discuss this approach with developers
familiar with CRIU, systemd, and the kernel LUO infrastructure,
particularly regarding the following questions:

1. Should systemd be the exclusive owner of `/dev/liveupdate` and manage
the lifecycle of LUO sessions?

2. Could CRIU obtain a LUO session FD through systemd, for example using
the `LUOSession=` mechanism, without fundamentally changing its
standalone command-line usage model?
(I have already verified that CRIU can run as a systemd system service,
obtain the LUO session FD from systemd, and successfully complete the
checkpoint/restore process, with systemd retaining and restoring the
session FD.)

3. More generally, for standalone command-line tools that need to use
LUO, are they also expected to run as systemd services in order to
obtain a LUO session FD? Or is there a way for such tools to retain
their standalone usage model while still obtaining a session FD managed
by systemd?

4. Is the existing systemd FD Store mechanism sufficient for this
purpose, or would an additional IPC mechanism be needed?

5. Are there alternative approaches that would better fit the existing
CRIU and systemd architectures?

My main concern is finding an approach that integrates naturally with
both projects without introducing unnecessary dependencies or
significantly changing how CRIU is currently used.

I will continue investigating how CRIU could adapt to a systemd-based
architecture. Any suggestions or feedback would be greatly appreciated.

Thanks everyone for your time and guidance!

Best regards,
Chenghao

