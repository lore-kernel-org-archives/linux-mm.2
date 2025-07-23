Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6F8C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1B08E002B; Wed, 23 Jul 2025 10:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288D58E0002; Wed, 23 Jul 2025 10:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6AF8E002B; Wed, 23 Jul 2025 10:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0998A8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:51:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B45C1C0720
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:51:38 +0000 (UTC)
X-FDA: 83695818276.26.CEFDC3F
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18DFC140006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:51:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+q8v1FB;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVnQRMG6JWHpYbsRA/rELCHaPGGpezCM9mPDQYF1C14=;
	b=ZO/HumrwVw76mEeYoXp9vi1k1VkhKQKFaxpheXbI0IKlW6xQC0DC1Un/SUQRTVUdr6eyVx
	ISt9Jfuozf92Urk1/bYjTeVv2mrbk2c+9SEHTPOeHULC42Ih4FTH9TvzRmLj5CZfnnxX+X
	arJpByw8w+7TQOAQpLp10/3FmsRInzA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d+q8v1FB;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282297; a=rsa-sha256;
	cv=none;
	b=RGKMvMtwaTylbf9NjW6mUbQPFgPwr1PT7TmKDtBiYPNhlo/ITn8+C25yCKDYkyCIJfIk1B
	cOwlkcQgxsyKe/xYr34HYHxaaEb4QnQ0PBZakxnCVQSdYxO5A8GrMIfa2pPQVvABPUffnE
	oPSPUudEtHmDA5e3qA6BRgtiIKeNWds=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6A0A7A53717;
	Wed, 23 Jul 2025 14:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B474C4CEFA;
	Wed, 23 Jul 2025 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753282296;
	bh=wVnQRMG6JWHpYbsRA/rELCHaPGGpezCM9mPDQYF1C14=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=d+q8v1FBgcxnd+Ik2rBSCWZH06NbbJGLl7cIHPMqFNbMvMUGu42r2+kOXuk1c4mKd
	 HOPd5PYTlzlUpjlw+7YAGxaJgxHExR7S+znJCf/bJhsTXGAmee0pyILoPDgKh9QAbe
	 m9OJ47WxhrHGFdNoBQ1VoBG5zv7QuTRxMy6Kb29Bv0g6yBajiE2EFMT+rY2IAJ3i+T
	 +vA+kxBAM0i02TaHS7vNlMMWFgBI0uEkuDXiO1wfgArKa8rsjS/oWQXIeIgMR2Z5nZ
	 BXdJz7u9bcB1C6uTiOp6o2eHXoM/RpOgqQc6sTQWzFJmtdkbtKivp519DSR/KCFwls
	 W8g2vZI8GJ/iQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Christian Brauner
 <brauner@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  jasonmiu@google.com,  graf@amazon.com,  changyuanl@google.com,
  rppt@kernel.org,  rientjes@google.com,  corbet@lwn.net,
  rdunlap@infradead.org,  ilpo.jarvinen@linux.intel.com,
  kanie@linux.alibaba.com,  ojeda@kernel.org,  aliceryhl@google.com,
  masahiroy@kernel.org,  akpm@linux-foundation.org,  tj@kernel.org,
  yoann.congal@smile.fr,  mmaurer@google.com,  roman.gushchin@linux.dev,
  chenridong@huawei.com,  axboe@kernel.dk,  mark.rutland@arm.com,
  jannh@google.com,  vincent.guittot@linaro.org,  hannes@cmpxchg.org,
  dan.j.williams@intel.com,  david@redhat.com,  joel.granados@kernel.org,
  rostedt@goodmis.org,  anna.schumaker@oracle.com,  song@kernel.org,
  zhangguopeng@kylinos.cn,  linux@weissschuh.net,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  gregkh@linuxfoundation.org,  tglx@linutronix.de,
  mingo@redhat.com,  bp@alien8.de,  dave.hansen@linux.intel.com,
  x86@kernel.org,  hpa@zytor.com,  rafael@kernel.org,  dakr@kernel.org,
  bartosz.golaszewski@linaro.org,  cw00.choi@samsung.com,
  myungjoo.ham@samsung.com,  yesanishhere@gmail.com,
  Jonathan.Cameron@huawei.com,  quic_zijuhu@quicinc.com,
  aleksander.lobakin@intel.com,  ira.weiny@intel.com,
  andriy.shevchenko@linux.intel.com,  leon@kernel.org,  lukas@wunner.de,
  bhelgaas@google.com,  wagi@kernel.org,  djeffery@redhat.com,
  stuart.w.hayes@gmail.com
Subject: Re: [RFC v2 10/16] luo: luo_ioctl: add ioctl interface
In-Reply-To: <CALzav=cUQGF_DnmyDOORssoThmfQwnPgUxQiLmXyAKY1-hyT4g@mail.gmail.com>
References: <20250515182322.117840-1-pasha.tatashin@soleen.com>
	<20250515182322.117840-11-pasha.tatashin@soleen.com>
	<20250624-akzeptabel-angreifbar-9095f4717ca4@brauner>
	<CA+CK2bBu4ex9O5kPcR7++DVg3RM8ZWg3BCpcc6CboJ=aG8mVmQ@mail.gmail.com>
	<20250625-akrobatisch-libellen-352997eb08ef@brauner>
	<CALzav=d+XgS1bUs-v7+ws5nYU9y=4uc1c8oVLHrJ16qLpnUi9Q@mail.gmail.com>
	<mafs0sejmse57.fsf@kernel.org>
	<CALzav=dhuoaS73ikufCf2D11Vq=jfMceYv0abdMxOdaHzmVR0g@mail.gmail.com>
	<mafs04iveu8gs.fsf@kernel.org>
	<CALzav=cUQGF_DnmyDOORssoThmfQwnPgUxQiLmXyAKY1-hyT4g@mail.gmail.com>
Date: Wed, 23 Jul 2025 16:51:26 +0200
Message-ID: <mafs0zfcvrmdt.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: i5wiffwjdqcg7c7pyfddw9u87unxpdpa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 18DFC140006
X-Rspam-User: 
X-HE-Tag: 1753282296-438612
X-HE-Meta: U2FsdGVkX195wjR8w+SgFM3VIM2WhCfWIz8Xe/6BBy2il/OH7RtLAFeDzgtiRRLpaQGxx5cbWZEVNfVkrVQeZRTHkqUgCDOiqlyIdGphTTg06N4mkTAwPGF6Ai5cH+I3VP5skaRCOUrnh34pc7N6m0be6Ez0RLdyKkSDJfNpO3OO9coIy3pDxgYObSdchqZriaydyTvMw+wcThnIY/PJoSf6E4pIAOXOilmhygk70sctsS2TaYNXZbEolxiYWpSKcO6ei5eeetEGaoTgrlIOkc9zrnEBW0tcakAHfrXrHpbyb51Ofb9T/pPEI3qOoKpvpqubXOUbCvGrjJkYK2ViWhLO4LpnT10ok48tldthbMDh68AqC8OWKfxzVuDAhilhYywQ/eJOiy6zekXxeMBKnfxqH7jBhyZepptifodAQeJYF8DJQpQTszqgGiGBhWNiFsL/8VSamw7/d934HEbingywf0+O1+pWjWuWgO8SAHb81jOtADv7gRqFNBfv0u2RA5SmE70qUdblBs/kaVYn+RiV14u3TQsagWMNZoRwslbhfsT6ba1l6eKBgrevyOg2TVrzrCEL3k+JQBiKl4qeH8eYMr8Qpu6WAj5M0dsAVB4tD2iV95nqpdW+Etn6ENyADtk9qzDQznmIwYryRg4Uj0reVpm8Mb+epwNLM4Q+kL6w+z11CRbXFcZ1GubjR3wwm4SkRoMeUGVSg0jnt11KzptAqNzWVsh2uXUJyX15c0z4ZjQQrj8pUJN1lCk29rZcP5fTegtKVic5RIHGREWukm97z+TFYlhNy8W5ua8iFgYt8TqpDNzk+7E+HO/WeQoosItmUxvz3AHWVsVO7Rw3Qov17AnKwyZCMMrofWlPUUD9fdPdFRU2EyfJB1YST/coXwKj7+ygCMgoJAu/iJWbUG+5+6blHPbE8J7zizsbfnVVZZMN6b0I1d3ACNXurGt8jyIv0NfKyb3+6mw0cZ5
 yNJFJKRk
 ABJwAnXUPIZ2KjJFSxwVvDXXPXetFkXN8C+l7SYEQOK9WwTuzAFMHu1vIiGvX+ZzMGEYjYZtLm070DCVbhX3FDOYe6889BdBhwNZ6/X4hkOfYcn80SWan8JLE7xxh/mKLKU+VqeH8/pwmmt/qw37H2FDBEG8zFQS1Yq8ingOYwH+2igoIBpGYO3Afg2dTIEbtNJD375P67VAp3NnrWp6ZXKKZAFZanZWXI9QxBZeuojxsB2IsYtdpB9JXnOnbzq/qSDfBOT21UGYTCgjS+tZhwYLjx3u3XclMghWQkMOIdVs0uDylJOXvkCydbObFD7c1yDz1IIH3CRIRgDnDj3eQAmruGzcYc0GU8w21yoBYPxxIOJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 17 2025, David Matlack wrote:

> On Mon, Jul 14, 2025 at 7:56=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>> On Thu, Jun 26 2025, David Matlack wrote:
>> > On Thu, Jun 26, 2025 at 8:42=E2=80=AFAM Pratyush Yadav <pratyush@kerne=
l.org> wrote:
>> >> On Wed, Jun 25 2025, David Matlack wrote:
>> >> > On Wed, Jun 25, 2025 at 2:36=E2=80=AFAM Christian Brauner <brauner@=
kernel.org> wrote:
[...]
>>
>> Isn't giving back the right kexecfs instance to the right VMM the main
>> problem? After a kexec, you need a way to make that policy decision. You
>> would need a userspace agent to do that.
>>
>> I think what you are suggesting does make a lot of sense -- the agent
>> should be handing out sessions instead of FDs, which would make FD
>> save/restore simpler for applications. But that can be done using the
>> ioctl interface as well. Each time you open() the /dev/liveupdate, you
>> get a new session. Instead of file FDs like memfd or iommufs, we can
>> have the agent hand out these session FDs and anything that was saved
>> using this session would be ready for restoring.
>>
>> My main point is that this can be done with the current interface as
>> well as kexecfs. I think there is very much a reason for considering
>> kexecfs (like not being dependent on devtmpfs), but I don't think this
>> is necessarily the main one.
>
> The main problem I'd like solved is requiring all FDs to preserved and
> restored in the context of a central daemon, since I think this will
> inevitably cause problems for KVM. I agree with you that this problem
> can also be solved in other ways, such as session FDs (good idea!).

Another benefit of session FDs: the central daemon can decide whether it
wants to check each FD it gives over to a process, or just give over a
session and let the process do whatever it wants. With the current
patches, only the former operation model can be implemented.

>> >
>> > Policy can be enforced by controlling access to kexecfs mounts. This
>> > naturally fits into the standard architecture of running untrusted VMs
>> > (e.g. using chroots and containers to enforce security and isolation).
>>
>> How? After a kexec, how do you tell which process can get which kexecfs
>> mount/instance? If any of them can get any, then we lose all sort of
>> policy enforcement.
>
> I was imagining it's up to whatever process/daemon creates the kexecfs
> instances before kexec is also responsible for reassociating them with
> the right processes after kexec.
>
> If you are asking how that association would be done mechanically, I
> was imagining it would be through a combination of filesystem
> permissions, mounts, and chroots. For example, the kexecfs instance
> for VM A would be mounted in VM A's chroot. VM A would then only have
> access to its own kexecfs instance.

Hmm, good point. This would be quite a clean way of doing it I think.

[...]

--=20
Regards,
Pratyush Yadav

