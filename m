Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2AECD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA4F6B0005; Thu, 11 Jun 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2256B0088; Thu, 11 Jun 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8046B008C; Thu, 11 Jun 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2B66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:55:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5FE2C2909
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:55:31 +0000 (UTC)
X-FDA: 84868535262.07.DC5DC2F
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCE7D140008
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:55:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b="lqoDUw/k";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S xhnnWM";
	spf=pass (imf23.hostedemail.com: domain of mail@johnericson.me designates 103.168.172.141 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781204129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPOHqYG+iRF3Ic0VkRMBbLpS+z9IKrHddDy3pi2hdIc=;
	b=ZhYYPaYAi76uIvTJqYQdWDw3FSLSloz2RLhzT6gt6RzWH8Q8tUpmw67bnegdWjmVXOZIGe
	1s1MLLixJmDMt+QBccG7dEcDJ/t+pULTPSmzs8BQXMN/VUVMD9dYLPd1td10aPNfTq8g4c
	IJQHBLeq07lYokdbzQ807MM02UdkxcU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781204129;
	b=BO2sf0tKLb2xxYU/+HqH7twR2fzrXyUMbnXSYYotA3RZteOs+g7Wl4FN4hHsXSfnYzDCj1
	d8k5TH5hELiBWtY+PYYVe1qW9ANntCD+u4JOfEeDdvVvXneFEHj9R62BNFJ3FDne0Si0FM
	RrofIjYpC9PxIx5HQXhiMrHhaTN0lQU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=johnericson.me header.s=fm3 header.b="lqoDUw/k";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="S xhnnWM";
	spf=pass (imf23.hostedemail.com: domain of mail@johnericson.me designates 103.168.172.141 as permitted sender) smtp.mailfrom=mail@johnericson.me;
	dmarc=pass (policy=none) header.from=johnericson.me
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 1652F1380100;
	Thu, 11 Jun 2026 14:55:29 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-05.internal (MEProxy); Thu, 11 Jun 2026 14:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1781204129; x=1781211329; bh=hPOHqYG+iRF3Ic0VkRMBbLpS+z9IKrHd
	dDy3pi2hdIc=; b=lqoDUw/kVA743bATY9h3WK1dphY3DTGWmWqfS7rSB5GSVn1J
	as9WBsb+A9PKES5gRpl1K43ImpkJByEQ+OAGA8jgvTajebY1O93d+Ltmq8xdbZmr
	UpjrbAZH15xpPstw++7hFOY+AQmRLZsb2gRNFyC6VpRAlni/E62ZfUjR+2Y7ilDV
	5dalJkSjuO6iJHSs2PFitbvp8GbWY+Y4zFxsBDVzhzH13FnV4hN4gX3XoXsGEpU5
	VX6YHz30fcubjL8dS4nRv3IXpnfilOnuPUp8p3r0TTr6X+SeYW3CB5Ye/Y8JCFpK
	jE+5fg0CFoxi4Y/BBElq4gToBlMwJqp/uqu9MA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781204129; x=
	1781211329; bh=hPOHqYG+iRF3Ic0VkRMBbLpS+z9IKrHddDy3pi2hdIc=; b=S
	xhnnWMsEUraepm0he9orZCyxPfx/X2RF4T9x70S85+8jra4FIRU9EW5non7HfVsM
	Ci2TSpRE8DCnorJZZDCFAJnPbE74cU40UqUFdxQG06Ca0gf4YOU1CcSzAl7STslr
	hkiKH7TApmoVk+z9PZs+yoayKHgiTZtULPsVqW6Rrfak38XDnPycDho5FKzQBef1
	CY6QNcMEThwJpZ3k8dCfdqYEOgLqhPFyaSw/8plKCDA4ADs1atRjXiHektoDVGfc
	fFn8T2+BwlXB/s0NPeOq0qQ16jw7OASdZDZeHmvZZ39x54Pz2OrB2tDyBB1+NgYc
	5/H2msE/XBzMbGzzvKNHA==
X-ME-Sender: <xms:oAQralqwuh0eouA59R3_QIwyLFBttjzOXYhOIDERLdIbdk93hF5puA>
    <xme:oAQraifGdN2-ZAHIe6oNEDRfSEnR6WUhOwyGtPPn4ubpqD8tEdnDMeWgLTUy6Ii6x
    5vzuFyYmFZ2RIu87ORhcAz6vnLAsYx-tpUTNEZVfRt127tc0NsvnK0>
X-ME-Proxy-Cause: dmFkZTFYpPOn7LI4ucgrxMRuvUt0Pp7TpsmWzC1UMf5Uv3HNtfQ/V0DF7oE2QhImNcQ7/n
    hX3+SBSdsUULValjF705kUffDlbULeLEuQLe9sEh2MjAhjTTmycdP5MBvhnGe8dzZvyNon
    El9MmMNYiTmjnLQ2tcVKntlKTVipyiBsZrqxOGT4HbGXTm+q5nJv2ou/btyVBYEM9hCWwC
    5GGP97dtjAoQTfqjBznaZdB0rggqqROmubcwr/kzdeAmz621tqJGsS7RdmLEwmGJYTNNOO
    USKMjLfMmFc65L14V1RzajGF3g6WHSe5i+BYmpu3hA0CfgzgP+VZ8oTuBT+38JRx/yxzgs
    umnpTqvcNAd1NFNCHjofpW8OHDuMUHWjxpEVBjSNmRctxv64ki/DUB9+G7ogl7t9K3QVjK
    Ow2Y0fYcjWb7JTEpo/PoDYWzEvTk9XEek3xh+BpzUH00rvEY2PWP7ywJRQTdPoMcVAn7Gn
    r7cDKLJ65+s64x2Q942+XWGD/zOI1+7LvCGFjOH2uWfyZd0Fv7Ymr+gzCBsMoAv2xkL3T0
    CqD6YGWIlZSwWzrToYEFEdrCnD2xjZeUFFAtwMMKqgh8H1xdIFhWYk77oCQivDvMMOaL+9
    Tq0tCHKmG0ElxEfp2Q75UzEXsV7cS5F72NZyHP1i3LMypy67FGfWMnYliP7A
X-ME-Proxy: <xmx:oAQraroOprWSkLgJ-7djeMHTInI52a640Gjt5LslcKa87iD22lOadQ>
    <xmx:oAQraoatsZC0BtBctCPgAsy7fxQT3f9fqffQoMXyvPniBkKKuuh1bA>
    <xmx:oAQralHhcfx828vfIPwoTAB7RPq0-Rlkt4Jh2VvoK2hJ4cYJKq3hrQ>
    <xmx:oAQramZmlr4zGPtWbXjA0WPzKylSB7mfQzF7M44bZW6o1b9B_bhaGA>
    <xmx:oQQrarNSduaBJQ-qynqxxgQ-ZwyRh49OZambtOBojf-3vpyXdpA0tC_O>
Feedback-ID: ieb4144f1:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0C7D62CC0086; Thu, 11 Jun 2026 14:55:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AtGJywdvvpER
Date: Thu, 11 Jun 2026 14:53:10 -0400
From: "John Ericson" <mail@johnericson.me>
To: "Mateusz Guzik" <mjguzik@gmail.com>, "Li Chen" <me@linux.beauty>
Cc: "Andy Lutomirski" <luto@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Al Viro" <viro@zeniv.linux.org.uk>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 linux-api <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>,
 linux-doc <linux-doc@vger.kernel.org>,
 linux-kselftest <linux-kselftest@vger.kernel.org>, x86 <x86@kernel.org>,
 "Arnd Bergmann" <arnd@arndb.de>, "Thomas Gleixner" <tglx@kernel.org>,
 "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
 "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>
Message-Id: <9033ff42-9ee7-4b93-9570-a5adcd16e826@app.fastmail.com>
In-Reply-To: 
 <hd3i6pxxohsjesyid7nhuic6ppp6nyoxxpwa4mny6riqvpyqec@mylfprni2yaw>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
 <19eacd64508.26b92c022125848.262962729296162879@linux.beauty>
 <4e049396-377d-48a7-a34c-91318413a876@app.fastmail.com>
 <19eb181fdd4.6d028f442844776.3737831021032223216@linux.beauty>
 <hd3i6pxxohsjesyid7nhuic6ppp6nyoxxpwa4mny6riqvpyqec@mylfprni2yaw>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated executable
 startup
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCE7D140008
X-Stat-Signature: rbkh763ggt5er3m44d6px8fa6o8xihxw
X-HE-Tag: 1781204129-614305
X-HE-Meta: U2FsdGVkX1/kvi+t+MQkCYjk1rzlV3Je2fZXFjyFsJXJ6OWGyVdu3CSE5oHjkAcFhb6kpdsGUVO5K5g22BvcUE2J1YohZT0I7IUPNvAsVL+tG1WDLYEQx11YuCsGvc6XjDX4rz69tQWzp9p6oRbm/MoT0tMQ+kl7TZrt3VhtciH+Woctzgsd9ZkMvem2VyFmtamoTKRVuSZEjSCsVOFt61kRXzJ1NrGmMSTT2+BXq4huHJAtb/FL7lPvRkkYo5PWUP8bo9ysM6WnanlHMbwtr/TnQ1bk9pySmvXFBSdAal25rp49mPZph80pENLOEo9R8DX+a6vehAHPXE0yt1XKlZ1odBljhUHx7xSdoI9qJO8YDsgX0CvIAbRT3rYkkz4F1RF7/EXFURWF51xd8N44s/5rh52d2oi6uwImdY5wVbr2OCcRmC0ONSRn1HgtPbOnxNZ6w4q9FP3MW2lGaF1W5hf1oh/cmbnE/kL3VWZtPue7vGD7Ffc0kNpL+cWDyR2vkPS/Qv5+oJsoCySSKUaR/pb4lCJ4CW0ufkgYlD0/aJ7bHA2nzYZ49yDebKKMnAn+4DF0s+VJJK8+JhmHLUGWe8vhbnbnC9VcAHESFyoDZhde0aSyjer+mXpwhCviiqGnfNR7JeRZ2UaTtMX8E5iwTvbH4Cu3tDE0W0578rx252gi/73663/26kBg81uQSgALqRw/Y+M7oWh/8Cl+sjbGZbCEtv4O75OvfhfQxIXZe5wP+pMxa9YMtY7MPddosKM3BjBNEdG2vWZUzYT48BN3D8a8yYk4kY4Iu/iAfCovaoAHUzSAEPWKy0Z4dJ0wi4kWr3iZuyIjpNc0AHztgR3t8TRndBXAT81KqWDMolbCdp2pQftbBWViU2mhdCQERLppT/eNiiH3QnNSvXbbAb/q4xuWFDapLoLUlcZcrlt+l3SEWQZHKnEEjYUz7Ga1MEg1smU9ofHkHOPLAqdrd9x
 XTelij4c
 1Gr16OOdabjU3X0D9ZPdt55gCCsKCbupv/mLmaENzlU37OpF/M4m/5QEfOIv9hLFjFCzFQppYMChLHTFhHHATNorImX/Pgt8pgVoEvcuniWXyXrXPilcJE4gq9not+fswXqOSpg5Q//tEJhKH4G8MfGV4o5PL20jw4NbLIkJnkCGfJ5J8HHx19VuULu+gV9cV9OBAZI7QzMRB398scDZONougSsYCVn8Ap0UAHkJRBB2CrbfLeoTHzeH2l/Nkdh/DySWT+Su2jH7hhPn0u14qeh28VJq8LQhmYcFKtW2TUeBah81ilJPqg8jw0wZ2wIaBsbV53nEfokyJ3utZFQTWOIec99BJjVHhyOnN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026, at 7:40 PM, Mateusz Guzik wrote:
> [...]
>
> As I tried to explain in my previous e-mail this approach does not cut
> it because of NUMA.
>
> Suppose you have a machine with 2 nodes. The parent-to-be is running
> on node 0 and the child is intended to exec something on node 1.
>
> When the parent-to-be allocates and populates stuff, it takes place with
> memory backed by node 0. If you allocate task_struct, the file table and
> other frequently used (and modified!) objs in this way, you are
> guaranteeing performance loss due to interconnect traffic to access it.
>
> Trying to add plumbing so that all allocations respect numa placement is
> probably too cumbersome.

Are we sure that last part is true?

Let's also assume when this stuff was initially implemented, we didn't
have it. If the basic thrust of this work is to replace functions that
previously only worked on the current thread with those that worked on
either arbitrary (not yet started) threads or the current thread, would
that not prepare us for slowly migrating the allocation choice to
reflect the node of the target task (new parameter) rather than the node
of the current task over time?

(This assumes the task is pre-placed on a node before it is actually run
there, and that pre-placement happens as early in the allocation process
as possible, so subsequent allocations can read off the
partially-initialized task's node.)

"Slowly migrating" is good here! It doesn't need to be the fastest thing
out of the gate, but if this new proper spawning API gets popular as I
think it would, and there is a clear path to optimizing it per the
above, then I am confident that over the years it will happen.

> The primary example for that is looking up the binary to exec in the
> first place.
>
> userspace likes to pass paths which don't exist, meaning checking for
> the binary before any hard work is a useful optimization. Suppose the
> binary to be executed is in a container bound with a taskset using
> node 1 and the content of the fs part of the container is currently
> fully uncached.
>
> When you perform the lookup on node 0, you are populating a bunch of
> metadata (inode, dentry) using memory from that domain. But the intended
> user will only execute on node 1, again resulting in a performance loss.
>
> In order to not do it you would need to convince VFS to allocate memory
> elsewhere.

One thing I don't get about this is that isn't the cost doing a bunch of
work searching the PATH for the directories where the executable
*doesn't* exist? In the case of something like a shell that is going to
spawn a lot of processes, I would think it is *good* to keep all that
PATH crawling VFS filling to be on the shell's node, rather than the
child processes' nodes.

It is only the executable itself, the final step of the VFS crawl, that
should be loaded into the other NUMA nodes. Insofar as (unless I am
missing something) creating the process means finding the inode for the
executable but not loading those pages, aren't we OK here? Only when the
new process is actually scheduled and run must the ELF be paged into
memory, and then that will happen on the correct node.

> So I stand by my previous claim that ultimately a pristine child has to
> be created (like in this patch), but which also has to do the work on
> its own.

I have not been a kernel dev, so my apologies if I am missing things.
But in conclusion for me, the FS and other resource access patterns of
*creating a process* vs *that process itself running* do not seem
necessarily coincident to me. What you are describing as for sure a
problem might possibly be a *good thing*, if they are in fact quite
different.

> Suppose there is no explicit placement requested anywhere. Even in that
> case there are legitimate workloads which will eventually be forced to
> exec stuff on another node. Even these have a better chance retaining
> full locality if the child process does all the work.
>
> Per my previous message I don't see a clean interface to do it.
> something quasi-posix_spawn is probably the least bad way out, it will
> also allow userspace to easily wrap the new thing with posix_spawn
> itself.
>
> Also note there is another issue with the fd-based approach: the fd will
> get inherited on fork and will hang out in the child afterwards unless
> explicitly closed. Suppose you have a multithreaded program which likes
> to both fork(+no exec) and fork+exec. With the fd-based approach you
> have no means of stopping another thread from grabbing your state thanks
> to unix defaulting to copying everything. There was an attempt to fix
> this aspect with O_CLOFORK, but this got rejected.

I would think we don't need to worry about clone/fork very much, right?
I think the premise of your emails, and just about everyone else's in
this thread too, is that we agree fork+exec is bad, and the problem of
unnecessarily sharing resources is inherent to fork. Furthermore, I
think we all agree that while `O_CLOEXEC` and `O_CLOFORK` may help, both
are unsatisfying solutions because they are opt-out not opt-in, and
global to the parent process / preexec state (respectively) rather than
local to the specific fork / exec in question.

pidfds encounter these problems no more than any other
file-descriptor-based UAPI, right? And I don't think it is good to blame
any such file-descriptor-based UAPI when fork/exec are at fault.

Maybe during the transition, when some things use fork and some things
use this new API, stuff will be awkward, but I would rather that just be
an incentive to complete the transition away from fork, not a reason to
second-guess the plan.

Once the transition is complete, and everyone is diligently assembling
their child processes from scratch as is proposed, `O_CLOEXEC` and
`O_CLOFORK` are both unneeded, and oversharing privileges will be much
less common simply because "lazy coding"/"minimal typing" will only
share what is needed --- anything else is more code/keystrokes!

> Whatever exactly happens, NUMA is a sad fact of computing and needs to
> be accounted for. The approach as proposed not only does not do it, but
> it actively hinders such deployments.

Despite everything I said, I want to be clear that I do agree that NUMA
performance should be accounted for. Even if the first version isn't as
great as it could be on that metric, there should be a clear plan for
how future work can conclusively address it.

Cheers,

John

