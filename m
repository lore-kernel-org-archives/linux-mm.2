Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46288CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2FC6B008A; Tue, 13 Oct 2026 07:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3266B008C; Tue, 13 Oct 2026 07:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C4C6B0092; Tue, 13 Oct 2026 07:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7C5F6B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:02:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 665881609E8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:02:49 +0000 (UTC)
X-FDA: 85317315258.19.FEAF8DF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3DC9FC000A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:02:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791889367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lwnXpQs8h0RkpXoBgKrIw7VtMxZRGTucGgOpbdPBGLo=;
	b=7bBtlOTwpzOnZdXjoI4vpO7P4JwZ+9QqrCOUH3Mk6FCQM3BE/EP2/uNYQ4cnrFqEtMVcJH
	Xfzjidhud9CqsEkGmz60Rv1NhsP58iZNHPbdsu2wVeZcp2jRjPEnh1y/73782S4kvLp6Ag
	BdprKyJloIW5S98DycdWLBK3ddRU8yY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791889367;
	b=gIPg77+FiR4QNdKpGClO7E4N7DUJWNxKXiiLsb5EwIl2TWzvoIPvTo+rj11wf80Byzy9VM
	zFTlGfsLv5RKtt8Q2CGOn60Lys2vIL+0wrzINbeGjqjH03T1m3s+BZkiKuYUqAP+jXJ4M3
	lHxpHFmnj9LjRuMY54lDItV3+vrnZhg=
X-UUID: 9b23fc3ac6f511f19a56ed5b684f684d-20261013
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:6db9e078-1538-4d08-8ef9-9329f447ff6b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:597e9dc93505a2ad45b7ff19eaf9495b,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|136|850|865|898,TC:nil,Content:0|1
	5|50|99,EDM:-3|-100,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9b23fc3ac6f511f19a56ed5b684f684d-20261013
X-User: duanchenghao@kylinos.cn
Received: from localhost [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 675544311; Tue, 13 Oct 2026 19:02:39 +0800
Date: Tue, 13 Oct 2026 19:02:37 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: jianghaoran@kylinos.cn, avagin@gmail.com, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	systemd-devel@lists.freedesktop.org
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed
 service
Message-ID: <20261013110237.GA836401@chenghao-pc>
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
 <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
X-Stat-Signature: 9d9b19rzo57i1dff9us5g5ae34hbobzt
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DC9FC000A
X-Rspamd-Server: rspam08
X-HE-Tag: 1791889365-904796
X-HE-Meta: U2FsdGVkX19ZKLdQAr9/Rlthi3SbLNrtwNfApPVxm/Fuo56iumfmTZtcgRBoHKq6rNeHlIj24zNiTHodYc/TRn9A+pKYbig3wK0xSbCiRtOXTEouG09zQu1QarDs8Z29ZA68RWFRknlTjJuAbZAniJsPtjn1EWpiJl6X/kMvuhclQXdBbYVhfLWPS+sd6ygoWMpxgACHtnzrGSWY6a3orlrlSOjEr4yUwZ7L/8rDtt/dT/DRyCA9k5meW3mDUa1JfdsygX5cKRKzlLdjYP7SNtabX8HIs6ZlSrTlRW0IN3naVRr18by88VkrVyeT6LGA/fJaArYA4NnmiiBQtl02wfu5njHrh4hIsdhj6ih5IFs/eIoysaCV3HB6UukgDxXRfmSd2j234EESQQ/lItrmCw/D0a8BGsUYfNPiWTm8LpMEQEMhVqjsJ1qtk2lqDYUPfSONXpZpvJKH2LuW6yTflW4jMqAqMD6GPOxaMX3CJtTwQz0ZRyu7mnnroyqG7+ltJjQtrzpDUV6LhdGxASezVn6cxlt5hwQrdy/qi8nL7Oqgkffc/ZOBTLrZ/PyupnoPX+PNYnHwbGQBDzrY8HYiCKPi83r6Z+s2MWS9rrj1N4M2fhteYF7FE3Smm5+/aThjN22NKvgNtcnrgYR66L2Z4OU5xYbktR2agwZAtCYptcm6ItMs4UYB36/oW8NljAecTj6hbn40cBDk6jcyDq9yIDyEDztR6MWVwjlcRCSu0QnLfgsr7sQoWdu0ER92PkA2DQuJT1rAUU/MIGNts/ke8F4suVcdiKYSbZIaRw0OEhtMK+pi+cF8Y/oprT47Czfwgag3aDP0Jboq3u7inoTcI9A3YoZeg4BeY7gowEU69qP4qpxARD8ggrYW7+j337XKqp7HQRdmLgYPO4Lzw7QO0/FQ4VqNLxOey+62QYSGqfAwzlric5+TsmuZJTQvuCThwhwKB5toNvYAHYhXVlm
 5Gxy2zCz
 Vjwif6tcYXlBjQVE9UpVFBAbh1cHOUv3vM47iAA3Q/1WLtllVJKtlNfKyALae6qxn/8+E49nFATYd1pouZChIFUzCNlC1aNaPEgP1Z+KTudJ6Snysl5oSNem0L82q1Xcigqeowct3+q4tNryRgl2mXh4ZC4rqO8gUqUkKAS3gMtVWkpQYHTG8BMUMqZDITzQoeJDnZFhZy77BoCrP48rRJqPbyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 03:05:40PM +0200, Luca Boccassi wrote:
> On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> >
> > Hi Luca,
> >
> > I watched your excellent presentation from the LPC conference in Prague.
> >
> > I have a question I’d like to consult with you.
> >
> > I am currently working on the `memfd_luo` feature in CRIU. My goal is to
> > leverage the LUO capability to store checkpoint images inside memfds.
> > After a kexec reboot, the image data will be retrieved directly from
> > memory instead of from disk.
> >
> > Here is my pull request on the CRIU GitHub repository:
> > https://github.com/checkpoint-restore/criu/pull/3152
> >
> > In the PR discussion, avagin suggested using systemd as the CRIU daemon
> > to centrally manage LUO sessions and access to `/dev/liveupdate`. I have
> > watched your talk and read parts of the systemd source code.
> >
> > From my understanding, systemd currently provides a unit‑based solution
> > where child processes can inherit LUO session file descriptors. However,
> > this approach requires the target service to run as a child of a systemd
> > unit. As far as I know, CRIU does not run as a systemd‑managed service.
> >
> > So my question is: for services such as CRIU that are **not systemd‑managed
> > child services**, how can they obtain LUO‑session‑related file descriptors
> > managed by systemd?
> >
> > Thank you very much for reading this email. My knowledge of systemd is still
> > limited, so please feel free to correct me if I have misunderstood anything.
> >
> > Thanks & best regards,
> > Chenghao Duan <duanchenghao@kylinos.cn>
> 
> Hi,
> 
> At some point up in the stack, everything runs as a systemd unit, so
> it's only a question of figuring out in your setup how to pass the
> FD(s) up and down the stack.

Hi Luca,

Thanks for your reply.

The `LUOSession=` configuration only takes effect for services managed
by the system manager. If I run the CRIU command from an SSH login shell
as I am doing now, the environment belongs to a transient unit under the
user manager. In this case, we cannot use `LUOSession=` to obtain the
LUO session fd via systemd. Does this mean the process needs to open
`/dev/liveupdate` by itself to create the session fd?

Below is the attached service of the process found via `systemctl status`.

[root@localhost criu]# ps -ef |grep criu
root       57589    7729  0 18:25 pts/2    00:00:00 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4
root       57784    7571  0 18:27 pts/0    00:00:00 grep --color=auto criu
[root@localhost criu]# systemctl status 57589
● session-5.scope - Session 5 of User root
     Loaded: loaded (/run/systemd/transient/session-5.scope; transient)
  Transient: yes
     Active: active (running) since Tue 2026-10-13 10:03:55 CST; 8h ago
      Tasks: 4
     Memory: 148.9M (peak: 1.3G)
        CPU: 47.000s
     CGroup: /user.slice/user-0.slice/session-5.scope
             ├─ 7712 "sshd: root [priv]"
             ├─ 7724 "sshd: root@pts/2"
             ├─ 7729 -bash
             └─57589 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4

I'm not sure whether my understanding is correct. Could you please
provide your feedback?


BRs
Chenghao

