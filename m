Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E9D606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 10:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561E36B0206; Wed, 21 Oct 2026 06:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5396A6B06AC; Wed, 21 Oct 2026 06:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F946B06AE; Wed, 21 Oct 2026 06:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 214FE6B0206
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:36:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E29280494
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:36:53 +0000 (UTC)
X-FDA: 85346280306.20.B43926A
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf01.hostedemail.com (Postfix) with ESMTP id 407C540008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:36:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792579011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4a8dTd8W549kARPYgxWqM4QrBiNO4UU5WeCrYJf8hzI=;
	b=Ynr6c/KMHwLbDSx+HI0y8ZEna0mheZuDO24iO1YuhTd3apMqELM/5SfjZ1DE+/2wDLlxV5
	y/fReLpTiuXruCcKFbVtYAvtYtLv/EbMwN/aFY6lSgAMmthxFFEgmTTyHu07et/CVb1aDK
	pSVZtAv1xji5UWG4klAbnUHGb1QDHJ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of duanchenghao@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=duanchenghao@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792579011;
	b=mCzNojqIY6jUJLGY7766dUakIV6ixE6Z9LNHvqitP0pDWQ6UuBsaeQNT2h9AmDuq1Ak/3f
	d2q8YRYoJePbVUichYvmuCKSnXZ9XvFX9I+q12m5tg9hfJjKBFE2jSUTH1+svgZbqcCG9I
	FXrERLndOPI+xXGsLu1DPmncIkpJFMA=
X-UUID: 4ab90578cd3b11f19a56ed5b684f684d-20261021
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_TXT
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5cdad1f0-615d-41c5-809a-f2fe534bd61e,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:5cdad1f0-615d-41c5-809a-f2fe534bd61e,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:1bd38fda213d37dd9cd1ec9cf075d221,BulkI
	D:261010210608FCZ9WBJC,BulkQuantity:7,SF:10|64|66|78|80|81|82|83|102|127|1
	36|841|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:1,File:
	nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:
	0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4ab90578cd3b11f19a56ed5b684f684d-20261021
X-User: duanchenghao@kylinos.cn
Received: from localhost [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <duanchenghao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1052165201; Wed, 21 Oct 2026 18:36:36 +0800
Date: Wed, 21 Oct 2026 18:36:33 +0800
From: Chenghao Duan <duanchenghao@kylinos.cn>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: jianghaoran@kylinos.cn, avagin@gmail.com, linux-mm@kvack.org,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	systemd-devel@lists.freedesktop.org
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed
 service
Message-ID: <20261021103633.GA1324331@chenghao-pc>
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
 <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
 <20261013110237.GA836401@chenghao-pc>
 <CAMw=ZnTksVT1wuQwAjzz_2tYSCvLSxeUBa3mYQvCFuKUtcydaA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMw=ZnTksVT1wuQwAjzz_2tYSCvLSxeUBa3mYQvCFuKUtcydaA@mail.gmail.com>
X-Rspamd-Queue-Id: 407C540008
X-Stat-Signature: uh87dbqpkgadi7xqux4kkjryok6xew6c
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792579009-495589
X-HE-Meta: U2FsdGVkX1+MPxIun75HVGvkHD1ZLWzOhfnfyo8qVJ71WlR9J/uxNjStUMN7AfUDsHzrErQHsdUpwbX4c6AddpreYM9WGunHifAd789MpcLadyuuFDxxjt1dXZPuLG8OacuiyOOIuKb/bjXw1kHGWnXsJ88PsTQN44xq3TWvO+w8X/OtKbAmfa4PW6IucK2PDdVytArwodF1HIVrcagTrdzTzJ4bi7vGK5xp4xZTPxAysfIehkAozSX5UDgcD+Mwp3HiGFFuw6ttGNB1/ewp5Dsqqtfj2nRaewvXYp2VO4njC20csUsDFzJtNX1FHsNh3o6ypRZMbd694mXGaNGGgPslHK/7el8LlvXZ3RNpt9rH41Cn8bQMPkoavSals39UgXPTKmex8lxfH4DQaWyMu/JIUUXDRQG6b6uKq+Ko5b7JOJ54E5kADn1EiwSQl83FhqRB6RlIovNB0y7G5vaBixDTD9TAJR8rj6IIxaMhHryT17+p1Wn5397xRktUvrH6UXqmdD/gim8srhonchBCaNo30klDBrs7DodkCJkg2Hl4s26i50ajohCURJMz70/KvulQA7ke/IyQVCYyi/oE7hCLDOFNAp5LlAboUII2ug/MqsGI50olm6/wGjN3t7/YdOFHsszA2LCRA5JD5r5guoxxiuBXU1v4jBKESXwh3XAnV1qu4Lgs4RxBUAz2J+B0t1ggFMwm8iLLaMKaIt71j7dIFU/p8qLlDIkhYrXM+P8Ss1HlzlSCQRTNK5V2x+HZoN73VczBAjyFasnlnsfQES25EgYE88JmNBdhkossSSXV7+YFlLewZV/bjcfIqzxuMZXLKND74GyawIDG3QKPyv4BfCOmCnaMh3XANIJHqg8RdhLSymXd+ByEN4bQMnoCDWauWAArUHuQK+yKR9V+nVj3tvwhiiGHZLYIQopAfaGfK8SpU7yAXMszSXtrrikMi895RaWbuHV3RN5Hwk6
 maInKY53
 9obvtvAf5C+dOw8xbw2n08XX2DWCWxBoZYVXVVwce/Y0bHtz+7PSyU9GL4WdbjMg5dhfauaUvjnMfvEk+8DCtZO6+6DSXA02pFQDeFYVSfRf9elc4EmG6x8FApXUfyX/05FuyEAiYeH9AGXT8EfSQSYiwxqYrkNuHtwRLVQnLe1tAHJduMvX0zRxI2WZb4Uw3oEbEQ9OYlluHybWGQ/2f5SBWF9JqqePnugFcQxlFShdg/F/GWvRxliKxglXTissbsZEz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 01:13:28PM +0100, Luca Boccassi wrote:
> On Tue, 13 Oct 2026 at 12:02, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> >
> > On Sat, Oct 10, 2026 at 03:05:40PM +0200, Luca Boccassi wrote:
> > > On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.cn> wrote:
> > > >
> > > > Hi Luca,
> > > >
> > > > I watched your excellent presentation from the LPC conference in Prague.
> > > >
> > > > I have a question I’d like to consult with you.
> > > >
> > > > I am currently working on the `memfd_luo` feature in CRIU. My goal is to
> > > > leverage the LUO capability to store checkpoint images inside memfds.
> > > > After a kexec reboot, the image data will be retrieved directly from
> > > > memory instead of from disk.
> > > >
> > > > Here is my pull request on the CRIU GitHub repository:
> > > > https://github.com/checkpoint-restore/criu/pull/3152
> > > >
> > > > In the PR discussion, avagin suggested using systemd as the CRIU daemon
> > > > to centrally manage LUO sessions and access to `/dev/liveupdate`. I have
> > > > watched your talk and read parts of the systemd source code.
> > > >
> > > > From my understanding, systemd currently provides a unit‑based solution
> > > > where child processes can inherit LUO session file descriptors. However,
> > > > this approach requires the target service to run as a child of a systemd
> > > > unit. As far as I know, CRIU does not run as a systemd‑managed service.
> > > >
> > > > So my question is: for services such as CRIU that are **not systemd‑managed
> > > > child services**, how can they obtain LUO‑session‑related file descriptors
> > > > managed by systemd?
> > > >
> > > > Thank you very much for reading this email. My knowledge of systemd is still
> > > > limited, so please feel free to correct me if I have misunderstood anything.
> > > >
> > > > Thanks & best regards,
> > > > Chenghao Duan <duanchenghao@kylinos.cn>
> > >
> > > Hi,
> > >
> > > At some point up in the stack, everything runs as a systemd unit, so
> > > it's only a question of figuring out in your setup how to pass the
> > > FD(s) up and down the stack.
> >
> > Hi Luca,
> >
> > Thanks for your reply.
> >
> > The `LUOSession=` configuration only takes effect for services managed
> > by the system manager. If I run the CRIU command from an SSH login shell
> > as I am doing now, the environment belongs to a transient unit under the
> > user manager. In this case, we cannot use `LUOSession=` to obtain the
> > LUO session fd via systemd. Does this mean the process needs to open
> > `/dev/liveupdate` by itself to create the session fd?
> >
> > Below is the attached service of the process found via `systemctl status`.
> >
> > [root@localhost criu]# ps -ef |grep criu
> > root       57589    7729  0 18:25 pts/2    00:00:00 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4
> > root       57784    7571  0 18:27 pts/0    00:00:00 grep --color=auto criu
> > [root@localhost criu]# systemctl status 57589
> > ● session-5.scope - Session 5 of User root
> >      Loaded: loaded (/run/systemd/transient/session-5.scope; transient)
> >   Transient: yes
> >      Active: active (running) since Tue 2026-10-13 10:03:55 CST; 8h ago
> >       Tasks: 4
> >      Memory: 148.9M (peak: 1.3G)
> >         CPU: 47.000s
> >      CGroup: /user.slice/user-0.slice/session-5.scope
> >              ├─ 7712 "sshd: root [priv]"
> >              ├─ 7724 "sshd: root@pts/2"
> >              ├─ 7729 -bash
> >              └─57589 ./criu/criu dump -D ../test -t 52922 -j --memfd-images -v4
> >
> > I'm not sure whether my understanding is correct. Could you please
> > provide your feedback?
> 
> That's a user unit, and as per the documentation LUOSession= is only
> supported for system units. So yes you have to provide your program
> with privileged access to the character device and create the session
> yourself, and then stash it in the FD Store as normal.
Hi Luca,

Thanks for your clarification.
I now have a rough idea for the implementation: CRIU will leverage the
FD Store facility to deposit the memfd into systemd’s file descriptor
store. As FD Store is tied to a service unit, a criu.service is
required. The unit file I intend to use is shown below:

[Service]
Type=oneshot
RemainAfterExit=yes
FileDescriptorStoreMax=10
FileDescriptorStorePreserve=yes
ExecStart=criu command

Does this setup conform to the original design intent of systemd FD
Store and LUO? Please feel free to point out any mistakes.

BRs,
Chenghao

