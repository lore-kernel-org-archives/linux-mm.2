Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2932A606A320
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=themaw.net header.i=@themaw.net header.a=rsa-sha256 header.s=fm1 header.b=SlzWuXRT;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=vcwJoROo
Received: by kanga.kvack.org (Postfix)
	id 09AB56B0854; Wed, 21 Oct 2026 22:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0728F6B0856; Wed, 21 Oct 2026 22:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA866B0857; Wed, 21 Oct 2026 22:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5FB56B0854
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:46:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0734A8101
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:46:43 +0000 (UTC)
X-FDA: 85348724286.27.00A625D
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf17.hostedemail.com (Postfix) with ESMTP id 782EB40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:46:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=SlzWuXRT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v cwJoRO";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf17.hostedemail.com: domain of raven@themaw.net designates 103.168.172.156 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792637201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b8JrLeZmohBXZxoZ8hIHhxCw9MvjJJNFtjwd/KPNiN4=;
	b=nqNXDCx8BuJm+YyhrByMYZCR/gKYgZfxpB93wfa4cwg23wyLw/EMXGDqyL/+6pdZIntymY
	Ct0btq8JGji100qvUqOiqrzfSL99SKFtjBQggayjkT1gHsThWLPuVF3CfhTp9KDslmggwG
	AtdhhuKn12tstO5MIGz0z+8jcLwGlK8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=themaw.net header.s=fm1 header.b=SlzWuXRT;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="v cwJoRO";
	dmarc=pass (policy=none) header.from=themaw.net;
	spf=pass (imf17.hostedemail.com: domain of raven@themaw.net designates 103.168.172.156 as permitted sender) smtp.mailfrom=raven@themaw.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792637201;
	b=npT/nXupJNn6cVV2Cyjk2k5MxrZURP7pBPlVyje3XPC/2LeMYphwG+9FKXIs/L25PXMDnL
	71HJoU03nxORSCL3iuM5lf9JK8bhn2e7MkIdmSZw+F1B+IpG4ssEWHmT3sUU608ImZX4DL
	cJRxcKfxCwX3AJg7DrGwkqqSnPOdNXA=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D69EA14001CA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:46:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 21 Oct 2026 22:46:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1792637200;
	 x=1792723600; bh=b8JrLeZmohBXZxoZ8hIHhxCw9MvjJJNFtjwd/KPNiN4=; b=
	SlzWuXRTtBF2qXe9jA6lVX3HJSnkinOlCatePQkTUUTQmyOpN6ZrpISLmgygl0Xe
	Cc81PlfuVQ5J6LAm5cZgQNj9+765p4wfd3ua4iqIaNYC9dhjs7ATJn27lFXZLC/l
	Vvy4qc6aoJKcQPUYoPgLJmhnZiYSx5Q/co/pEXf5/J/mFYrSk/D+T2A/K4ZyM8ev
	WuVpJdkFbpbZHHCI6imGoWGp4HBDlGgOHBTgsCBKACPSVO7go1iqlhs8JUfle+Bp
	66ruuiDLVU3oBtj351ArawJOSrWG40DTygF2Qd1BXE16XRqWLWSiel2q8ZHfGrUF
	W+qIlmdg7QYnDBaCIO1Snw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1792637200; x=
	1792723600; bh=b8JrLeZmohBXZxoZ8hIHhxCw9MvjJJNFtjwd/KPNiN4=; b=v
	cwJoROojIG7D8Yiyo6V0wr9zJ2pRVIh71PjrTRn4b+6YL5sSTwTY+7P7EB9lwh+/
	DgH1RyTg6cKTNYtiCzaE0wI9A8W6AgLUJlSEbk/fTD7zU/ZhLFKcyrIUauUH1y2A
	QYZEiekK3gSDR90Ln0u6yMi+ZBrfsn7f0S9Tf2ywJHki9gbE14mIuX/gzivUAOdS
	Cma0bCSSOLlye+1WSmxdjF1tiiG4XwCFqwaspRg21z7djT/2sh/3+f4JTt5+M8Kk
	7NLNa4Qd2Imv5mq7Hteo5kGIGgnEE3sT/Kfi1+q9zWSBPXL8j1/3mZNR194Dwsrj
	Gd2lcQjDOCSHGyYklAHJA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=themaw.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792637200; d=themaw.net;
	mf=PHJhdmVuQHRoZW1hdy5uZXQ+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:KRZt0IhE8q0zvF8qNEkGMeiLPp3wOjBpgVk8S9n0VzD27Xn
	APdfm6ArUNHsGwchOcybjvfDipTkKL8FuO1NmHxvvw8G0ZKQ1cd962yzALZIBRI7
	4m4GoE2V5yPJ2wb4Kn2fBVwa5XF/o5SL9Q8tKJ4sfrNgighm4v2uS9njb4GA0Yvq
	1jw2H2t3LAF0RoBanFocPHRzD/kKTfzQZgBNCt5i5oh3VSfnU6Ns7l9opj97cwol
	GP0SuET31X2uveH6Q7kTPDs9kSzy6sZw82JW0SDWn+z+fRrLhrOeLMG5uZvvCCI5
	Ws4hqXV34fbpG0Si69ZZrZ2WMorUWtL5Ul57+jQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:sdIH6ghOfrgTjW7puJZHRJZvIDPGFStH0tPZPwlN6IY=:b8JrLeZmohBXZxoZ8hIHhxCw9MvjJJNFtjwd/KPNiN4=;
X-ME-Sender: <xms:D3nZanyYcTuh1SY80zX_Z3VtYIcnX1BBY-veSqerCBSt1doqa07t-g>
    <xme:D3nZamOykI2EFyFkWfEQmZBOI0PChO7v-hJGRuVXaGDdRxXTVwMYKBZ7a3UWWH1ie
    0wFBf-nNgac8cM40_1LQq8MsCTxPG02K1VsP2AXBzRBHIBmRQ>
X-ME-Received: <xmr:D3nZamY4FEZChR6xmOHcfGReLpYofWK_kp1dlI4Zr0JZdcyX4NIsDRciIpTIpQMClhpxXEvmjwj0sZwKY-PCB50KB4IQmiDvalX4Nn6fX_Quu4q5gHoPw9a8dVE>
X-ME-Proxy-Cause: dmFkZTFJl80OlkxtKrmLpLry8SB+s8EoAdfs4E9kpHOA5dqijSHh+7H/6Ivwl3c5UQ6DPU
    41bDxgYzHplpsNoe8kwgDj4e1PKdBedBJV72Q4qA5wkBs8ODrr/9rPxc2zUUd+tnYjIwoT
    ny8AmIaquX3FxGlVZ0wxUuvq9UzFvwMAZ6TafguFw1d36OZgJRVxv2eQRkdEHm1vVeHXFF
    enmny/KR7qloN3pF57Mt7BDSlLtYw5ioXv2HFdYDF3laRnOa69O9gEnqzvDWKnOWL+0mIp
    HHUGTUNCYNktwxR355RyWy/dARgku5E1Vam+5YCKNnxnJoQuSH4/+wb6ScnHEQ3FIY85MV
    AAKXP32OP+0nQTkUZkb3NJlSRBIDpgT3rTLeB7cgMiC4kZHDuhR4f2GzJiGfZSvkpaVFOP
    cdlLoxz0KKAOhQPEgAUXJIN8/Uf8MWooH7GFvNoWioufSIH7cfK76aZxRoHTb5pIC3fKB9
    IrXPlTrMZ0z5RGiu/PDUyXn43KzDEn8Gye3Vf1cyrB0QyRIer9FCFe7jiOgcbOZGbFwpih
    OXLMN/2oBAih4161kXuTVBxcIypuUYKmasZEXorhy9h6zgyfGvDLpZ909if6Ry7f6MKQQx
    9xmQ6YWBNfFkmT4h1lMILcX2FXpoU1mRB3zuEOk4y7LUlL26+NtemFD+R7/Q
X-ME-Proxy: <xmx:D3nZaorfBZiF8DSOEZG9VScubghi4xX2nS4sv7IJtC3MTIqGtPOUuw>
    <xmx:D3nZajwe7dqGiUq7V8x9yzWXpiTmXTyOtphxRL3efFi5e2Oux14WPA>
    <xmx:D3nZagKfQaQFfha9UVcQtj1T_EGDbTHRmsjFyN5gd1dg44283zuzVQ>
    <xmx:D3nZal7I8GnVfCh0yAw6Y7uSPUxVAHpDmybX3LJZ4_ChcJOfw3cg5g>
    <xmx:EHnZarKh3r5ZAsnP8-S-yuCxUC58gm0culffZA-oAHtI_8qarITqTtyZ>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Oct 2026 22:46:34 -0400 (EDT)
Message-ID: <22d41f2a5546d3bc90a1b3ad24ed3656588a854f.camel@themaw.net>
Subject: Re: [PATCH 0/2] kernfs, autofs: fix pipe lock cycles through sysfs
 stores
From: Ian Kent <raven@themaw.net>
To: Tejun Heo <tj@kernel.org>, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"	
 <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
	 <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra	
 <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Jens
 Axboe	 <axboe@kernel.dk>, driver-core@lists.linux.dev,
 autofs@vger.kernel.org, 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 
	syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
Date: Thu, 22 Oct 2026 10:46:30 +0800
In-Reply-To: <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
References: <6aa23178.f81106d8.2ab401.0006.GAE@google.com>
	 <cover.1792577179.git.krystianmkaniewski@gmail.com>
	 <649966b83b39fcdd25e892fc3c6732a1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44app2) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 782EB40002
X-Stat-Signature: w1iusnqm1en8hap7ttuqc7cmpa4e34i3
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792637201-224308
X-HE-Meta: U2FsdGVkX19uo7HcrFbjhSflL+FrbX0gkYVZkespxEFNpTNpEzSiWERdNMk68gkP6fB6S/gRwtodxf5vX9yBI8XmVQSUaJkEg1XfdVfjiZcD+3nmUcLxV72QbxbX9tBhCDa3UY7uqL/5ZOrreCqDqorDl9N/ncn8ykw4TerP07m5E7expZF8M5kH7sojZnFdKh0H1XiHc2eFFK4QebQRcandmc//BXemwoUIjJQlKZqhIPLH5vpT7vikuTmSQGA6ay3z4WgTPBDu+3vX9kcIzP48BfIOomOkQYGBnXJIGL7Ss3djxk5NuPqXbX9ug3hURR0R1WBgZQw+UzZl2Fe/KGydVpAmWH8kidb1vCCFJrVWOXo8seNeW6iBNxYgZpFcSZ5YYBDvNP5QHCM+/on1OHFWYSS8Sl8i8sBCoADeKwW55amYUfPt48/kwFrMQrnN01AASWsmIOu0qijjzZJKW7v1BhYtIJ8onksqbhOlEVUPFab7kptJuqkbIMRjreP1dO//SOxCfZ4dmHsR1sKnzH5BKSjE9YHoRi+x9P/yyqyyyOTfkPVZXhTDvY2kSdn4qjjvXKnCEH06c4MlNNB+ZVaqiuMllRfUL13tyCW9XHguZlQ7AJYJuRXX60sE8vpcBqaLZuhDacCiF6PTrivAPksVb202OfFSTVvyTeI54XSMHgRXGZeFzHrq0tkMdxjspWPpVPQks/2hidl7jWIen3ixHK4LzBRGvXspwZTkE6OcuQdEKAQTAmaGMpCPtBI805bfchlUT+Fsy6dN8hoDTwxthhDRmInuu+QIoB2fvNqOLQqoPmtL3Mcc6LTraEsLO0kxloggnvqTAUDNTFVniNrPgObDHSIwVJMHZ3F0p5paT/EUoZ2Mc6puyzwYefY/Ry7N86dyuQNh9il8Ht5R0PPa9CP/C4iragVUUiYL8cBAqWN2NwFcHanJXnY82z3A5TZyOL6AfzwiIcFXS8E
 gHVl8T7v
 DM6mMG6XEAw4y8rDuLkCiyeimebR7+W0BrsZL8lyqbb6YMWn+oOsrrb6YcWuA029EryQfd8Sw1iZ36QflY1HbaZJTzbcxn5z+Hj0dY+KUsmVHABTLj9aRMCSg6mVcyPcFaIcSZg/f2wC2IGqxmfLmlustUA7YhCitmjlK5h+Zb2+ZpZZhnc3d8DM//2v36mCexxrCY4vxyr3wi2QU6G9n/J/DwEdadVHOhx7Y8Sy92GUSGYiPp681wp34Vsdy01LGDgNr8sDim07rFykk9VoH3PpV9sIThwBh7O55q7dWl+DUEIA5xgQwT8rMfQwdAvqHIxMoSu+dMwaoBK7Lu2Ogt3vSA27bkPcY2zBa5apW8uJR6HsoCp+GiiVHEdon6SJbQi3GnZjXaJPL16z3pTAXkiJRneDc4s1SQiSihQ9IKurztarF+cLYslTjeE1VGQ+3CNLsfUce/t5dVXR9wTCtZKSuqrKJOdB3/zYCGlUy/PYPh9qvxbrJ7Zs35rghrcYbiYsAi9RQyDUV+RhQh7ygSy9HPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 2026-10-21 at 11:48 -1000, Tejun Heo wrote:
> Hello, Krystian.
>=20
> On Wed, Oct 21, 2026 at 02:51:48PM +0200, Krystian Kaniewski wrote:
> > syzbot reports a lockdep cycle &pipe->mutex --> &of->mutex -->
> > &sbi->pipe_mutex. splice holds a pipe mutex while it calls the
> > write or
> > read handler of a kernfs file, kernfs takes of->mutex there, and a
> > write
> > to /sys/power/resume looks up a path that can make autofs write a
> > request
> > into its daemon pipe and wait for the daemon.
>=20
> This is an extremely convoluted case that isn't going to happen in
> any
> realistic scenario, and it doesn't make sense to change the locking
> scheme
> for it. Can we just disallow splice on /sys/power/resume instead?

I agree but it might not be as simple as disallowing that path.

Not only is the description hard to follow the example is flawed
because there should not be a mount callback on anything that's
not an empty directory or an autofs trigger mount (and the above
should be able to be either (systemd's /proc/sys/fs/binfmt_misc
is an example of an autofs trigger mount).

I mostly can't grok the reproducers for things like this so a
complicated description makes it so much harder to come up with
a sensible solution.

The other possibility I was thinking about when I saw that report
is to disallow file systems that don't make sense for automount.

That would take some thought though and isn't entirely clear for
kernfs since it's used by other file systems that may occasionally
need to automount something at some point.

OTOH, if the problem description could be cleaned up, and
simplified, I wouldn't be entirely against the change but still
wouldn't much like it. That's purely because I've always been in
favor of defensing programming even for cases that are unlikely.

Ian

