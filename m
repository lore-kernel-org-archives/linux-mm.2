Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88BB5EA8537
	for <linux-mm@archiver.kernel.org>; Sun,  8 Mar 2026 17:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47DB6B0005; Sun,  8 Mar 2026 13:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5696B0089; Sun,  8 Mar 2026 13:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC8C6B008A; Sun,  8 Mar 2026 13:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 881C76B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 13:41:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26DCC8C74C
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:41:19 +0000 (UTC)
X-FDA: 84523612278.18.1DFEF18
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id D79EDA000B
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 17:41:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+aKYojR;
	spf=pass (imf25.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772991677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gsaK4LeHfsp+BefHk+i0EQWqaH5qYyXSGTQN29Xs4Q=;
	b=5MdbxjkoCRLONc5goliwvOOmNX8aVELkAO0mf9D+/RbDYYTikWmED10nkL75w118WGPuL3
	hBOJNtGqAyhfQaKiiDeWofcjkywO8TOipGdnjKSplbwJqNd3xLSsL7Qm3OVRTojdRrqMQB
	mYCApgsKzFpZsX2ECpDbKviEK6yiUDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772991677; a=rsa-sha256;
	cv=none;
	b=gv8UqVbAqzgZcaBx1/d0kKiHKsddzWFNj6B80ZckWVpopw/eFDy2h9XH0fZP2lFuo4gtEm
	B88gTJ4EA6c/bRfEqqMZgLTD7XVlTYn+Y0qIuXAV12djsGA+KF46DEC5CLrhu7yMki6VhF
	Vspbm/VLiNHkBithYOzWfvkuOJFxlZk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+aKYojR;
	spf=pass (imf25.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439cd6b09f8so2929912f8f.3
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 10:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772991675; x=1773596475; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3gsaK4LeHfsp+BefHk+i0EQWqaH5qYyXSGTQN29Xs4Q=;
        b=h+aKYojRIkz4JFNT4DdskCgJhF+ap579zbdPhnTjg+S8mwa4oolBjO+J6lOdVSaLBY
         WSPKNGlhWhNH6ii1GtS7awTOHWnBXbqne595J69IwyEbpVKJtC4IwkE2PXfqudRmAiyu
         U4oc+drzkmSO8SVgaHjDVM50zESwp33x0jQ3kvD2bu1yJxxxdE6rsTCSvFRwbwGydWCK
         hGv5dJXM1AeSP37RU3l3enffmOGr1WfpdJcRUOKuJOxYXYoly7uv8CfZvNT4M0Uzmp6Q
         5NemKB056g73TxLWBxxfbAnvq/vL1nNQYuiL3v2FRwpjfdJ+vrzxnWNfeYnC6ESOieT4
         /hRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772991675; x=1773596475;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3gsaK4LeHfsp+BefHk+i0EQWqaH5qYyXSGTQN29Xs4Q=;
        b=AXiDMBT2mWrzih0gx7patQ6TPYlX+IOInorVRaWvIcr2QHXZR06UEDtk1Yj2GXMM35
         NBjcDtrQFtJsY5X3GwkwR6cZvi1fH9zv5VdhRlMqrx33XJx9BzmoAOa2j/fRE3XWqaI1
         ZUjoByhzOSI/0/UDAH4jjATLQkjT8ge+2JScQiCO9JH90TUpF7Fsdjif3rTBGWvbIM7W
         PmH1jDZtpXWZOdhiMMd5hFxZJwhDtc6WOUfrME4bU61PrrUpx11deZT+OdHbmiVyLAxW
         AayHIYO9Lm3vu2X5FUgiioTvbdeCdRIE/WyGgcKvirLDHwRglcXHbQmeyFrLl4XgQIix
         cFgg==
X-Forwarded-Encrypted: i=1; AJvYcCXpmlLk1xe9CbfKwc2cWzOa9bTqt9WHFbbWj62HVwys8dGpicu5Cye3zm+l1Mg2Awc3KUBu8OeH0g==@kvack.org
X-Gm-Message-State: AOJu0YzugszP+7yuh8xlKmBIlW6AeywIenVDa0BMJtLONEQinVytx5e6
	4KNxmNM3qeU14zfBgpfSJz2xNb/bH87if2bQuyQKBi4jriQ66PRRzNzN
X-Gm-Gg: ATEYQzxzUdXMa3m3R8Q42ePhdxoCD+3sqqyd0SZcp5U/9kWN6K9RqNHACgZxgVB0TXZ
	YJZxhvOlgcD8CtENufW6mpE7fjsPQf6AjcRRciYJBQ1F1lxDd3xVtXKtAGuNdUbcNbZfWA0r+Nn
	6IQTidgiadJNyIR/zja6PCgeDkbhe1e4+Z8lp8E3n+XnDMdD/jJDfQrMhh5ZXcYfKsV+Gvg8p8T
	7pIz84IklOVSE+hSPRwObEDepO/5oFt4+rOWokxQxDJ4axBywjrVcFjZxvoXf4hNtQkoUEJz2Zt
	FaLPvD6OO8U6195WhtQqjDcWGRJ08BEmWA5RBGnS/8x8WsJ5vQwii8bBgm4LCDrNQb5DzwIyzlf
	tX223La3lGchGX+RzYZJG36ENxww2NEETaA5zuzhCaoUwNP3PVXpMJizb9B+KZJGQN1OPgdeG7o
	joST3Y0NZHdQ7jyWuY3S1c1TgZoxV5NjjUw0Wf4QgNIR91Ig==
X-Received: by 2002:a05:6000:4283:b0:439:c9d6:4313 with SMTP id ffacd0b85a97d-439da369c4amr15406233f8f.44.1772991674882;
        Sun, 08 Mar 2026 10:41:14 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae3c80esm17542369f8f.29.2026.03.08.10.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 10:41:14 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Sun,  8 Mar 2026 14:41:12 -0300
Message-ID: <aa20uDGqnmiqYJ1w@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aaYpICV55B70U1I2@tpad>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka> <aZjY9h3XXMNY-Ytd@WindFlash> <aZwYmNuucBspCYhk@tiehlicka> <aaJDjmnfuo8AM6J9@WindFlash> <aaYpICV55B70U1I2@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eqkzaroqsw3ct46de6s7t6z1a5eyk16q
X-Rspam-User: 
X-Rspamd-Queue-Id: D79EDA000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1772991676-981095
X-HE-Meta: U2FsdGVkX187X+LTmnRVsGr3584dljze1rkxyJeX9g4uAloYmAQJpAHJEh05M4IqoNvawDVX7QTka9tHCnw/LtR76Aft6bdyBV66yu63kOjqxfQPMRe3UZiG/eMX2CZeAgYVKZ8fxS4ivzaimGhYYaSTvIOnIkp3Wx65b8tdQDrgAJyREqqxOn3UGCtUcJM7PiAuyqHUjGBeltXOsjFxX+XKbJkOzPkT+w+Re3sIT31E5MI1Z1a5wA2HgnyjX/whLvfxycoSxVmliG5n8weJksgIYQvoVGnF1ZhEA9B9kjxYmqJAvsZ/ade/jQUBeKUCbWOBGnxDktlnOob7dXvGu+L9mPmLQjA6mQrw2XHjQ/nVvnNSQESQt7++3q+S0g7Aw5OW4QCq3b0nHNj/z7b3IwflKBtC6IecxXOY9S9YM5zNy2zIM+jhbCoQn9NXG60MAd6sw6bwlRgH2Dhv5+rgrCDSnq7UTIGOkI1XLjhLjfW8qsjqZA3O05s5buk0MmIIuNE/287QdHsYwcvlNtIeF2x+NlMtl/+izDd36Fzwgokuj9ZGnahL0PqDMky8rQrsLk3++ErJnPXgugCyohCFbwVPss1f6kP5Bp8RNty8UnA5lthsgcVrN+3ibUbuE0wsOxodSCVABvPSS9x5CrPwmokVexVxfGgLK416PZKMm1LIDbRRASZ3pqyg+lgDh9+d18yXcw7mAfHp3iUOF2RyZmwQsT/G6t2vKTN7YVPcXEOj314paWyXO8zUFRBDd3YWHqLhlt6LY9yK1BRv9X8AEyv4dCiAlG7wq8SEiaxeT4ivGhFIZsGIEH/diSoEDrJxLICWeYfEkdMUkE776QY8rrtfwNwPeutVyEVRGF4bn1fd11Hc3dLuTggv/BVP/tov2o67O6mZrBk80KfOQsDawMjnYtOtZ9SyBJBztCRTIDVqkExHau7Ht1hYVbeTJeWN0rxrT9UPdggO8RXWSet
 3NwydlDe
 summ2yincss82iGkSee0PxxcmvVeaYv0GMRN8J2WcQaICDoTSPA9eQcazKlN37lSrd6OakRYHlHiwxGJPnQlvRuQeT3MTOfEtoJqv6t/+y9X+K6ajHWvbFm+YezGx7s14br55ykjdnFhqIHeVc715Yl5NAs4TaWwFRmoF3ZNWMXzvUsm3eNia5egd1rdroj82zc2NXDKjLO1SI+iuJT6vO2+ouiDXnuJfvSdHWwcyAIygfj65MO1qXSi0VmewRsHnG4nOwpA2A4812NGUU2qJCx/jzQkr5oAnsX7V6pMn6akXna3EOhxZV5owsHOBL7f501LJxUS1E7J5ugGM9qX6HlNIuWPp6a6wBC0yoSV3+u4em5VBnRt7hr/g7qkfqSpUs89N7W8FNlc+IZ5m3pE4UYnVdeV+4DF2N/gkjMqFBvVgUF2q784w/ylK1tNtK1AP6SmiQdrdGROSaEstPk8Azyl96n4Jpx8EaYOIDhJH9V3tpKmRGa/2WwdUwXQ0XXopXRE8m6IO47Xo3s2zIPL0qBTkVIEFQS79nW8R17HAPxaRLq1FBxjtUUCsOUnCrDyXKhyF9C6D3qQbFclMFsULpEFWUH/LDeEJT7LtJG3gxEMoTS/owd3yeUyZhPp7ep8cSWqM/sEhPNB38R5fSuDw2yntzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 09:19:44PM -0300, Marcelo Tosatti wrote:
> On Fri, Feb 27, 2026 at 10:23:27PM -0300, Leonardo Bras wrote:
> > On Mon, Feb 23, 2026 at 10:06:32AM +0100, Michal Hocko wrote:
> > > On Fri 20-02-26 18:58:14, Leonardo Bras wrote:
> > > > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > > > [...]
> > > > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > > > configurations AFAICS.
> > > > > > > > 
> > > > > > > > Michal,
> > > > > > > > 
> > > > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > > > 
> > > > > > > My bad. I've misread the config space of this.
> > > > > > > 
> > > > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > > > (and remote work via work_queue) is used.
> > > > > > > > 
> > > > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > > > to happen before return to userspace changes things related 
> > > > > > > > to avoidance of CPU interruption ?
> > > > > > > 
> > > > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > > > the work is still per-cpu.
> > > > > > > 
> > > > > > > In other words the approach Frederic is working on is to not change the
> > > > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > > > place - i.e. return to the userspace.
> > > > > > > 
> > > > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > > > paths like SLUB sheeves?
> > > > > > 
> > > > > > Hi Michal,
> > > > > > 
> > > > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > > > https://lpc.events/event/17/contributions/1484/ 
> > > > > > 
> > > > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > > > contention (I was not able to detect contention even after stress testing 
> > > > > > for weeks), nor relevant cacheline bouncing.
> > > > > > 
> > > > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > > > 
> > > > > > The performance impact noticed was mostly about jumping around in 
> > > > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > > > 
> > > > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > > > interruptions.
> > > > > > 
> > > > > > What do you think?
> > > > > 
> > > > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > > > do not expect the overhead to be really be really big. 
> > > > 
> > > > Awesome! Thanks for reviewing!
> > > > 
> > > > > To me, a much
> > > > > more important question is which of the two approaches is easier to
> > > > > maintain long term. The pcp work needs to be done one way or the other.
> > > > > Whether we want to tweak locking or do it at a very well defined time is
> > > > > the bigger question.
> > > > 
> > > > That crossed my mind as well, and I went with the idea of changing locking 
> > > > because I was working on workloads in which deferring work to a kernel 
> > > > re-entry would cause deadline misses as well. Or more critically, the 
> > > > drains could take forever, as some of those tasks would avoid returning to 
> > > > kernel as much as possible. 
> > > 
> > > Could you be more specific please?
> > 
> > Hi Michal,
> > Sorry for the delay
> > 
> > I think Marcelo covered some of the main topics earlier in this 
> > thread:
> > 
> > https://lore.kernel.org/all/aZ3ejedS7nE5mnva@tpad/
> > 
> > But in syntax:
> > - There are workloads that are projected not avoid as much as possible 
> > return to kernelspace, as they are either cpu intensive, or latency 
> > sensitive (RT workloads) such as low-latency automation.
> > 
> > There are scenarios such as industrial automation in which 
> > the applications are supposed to reply a request in less than 50us since it 
> > was generated (IIRC), so sched-out, dealing with interruptions, or syscalls 
> > are a no-go. In those cases, using cpu isolation is a must, and since it 
> > can stay really long running in userspace, it may take a very long time to 
> > do any syscall to actually perform the scheduled flush.
> > 
> > - Other workloads may need to use syscalls, or rely in interrupts, such as 
> > HPC, but it's also not interesting to take long on them, as the time spent 
> > there is time not used for processing the required data.
> > 
> > Let's say that for the sake of cpu isolation, a lot of different
> > requests made to given isolated cpu are batched to be run on syscall 
> > entry/exit. It means the next syscall may take much longer than 
> > usual.
> > - This may break other RT workloads such as  sensor/sound/image sampling, 
> > which could be generally ok with some of the faster syscalls for their 
> > application, and now may perceive an error because one of those syscalls 
> > took too long. 
> > 
> > While the qpw approach may cost a few extra cycles, it operates remotelly 
> > and makes the system a bit more predictable. 
> > 
> > Also, when I was planning the mechanism, I remember it was meant to add 
> > zero overhead in case of CONFIG_QPW=n, very little overhead in case of 
> > CONFIG_QPW=y + qpw=0 (a couple of static branches, possibly with the 
> > cost removed by the cpu branch predictor),  and only add a few cycles in 
> > case of qpw=1 + !RT. Which means we may be missing just a few adjustments 
> > to get there.
> 
> Leo,
> 
> v2 of the patchset adds only 2 cycles to CONFIG_QPW=y + qpw=0. 
> The larger overhead was due to migrate_disable, which is now (on v2)
> hidden inside the static branch.
> My bad.

Hi Marcelo,

Great, hiding migrate_disable under the static branch is the best scenario.

I wonder why we spend 2 cycles on the static branches, though, should be 
close to nothing unless the branch predictor is too busy already. Well, we 
can always try to optimize in a different way.

Thanks for the effort on this!
Leo


> 
> > BTW, if the numbers are not that great for your workloads, we could take a 
> > look at adding an extra QPW mode in which local_locks are taken in 
> > the fastpath and it allows the flush wq to be posponed to that point in 
> > syscall return that you mentioned. What I mean is that we don't need to be 
> > limitted to choosing between solutions, but instead allow the user (or 
> > distro) to choose the desired behavior.
> > 
> > Thanks!
> > Leo 
> 
> I think 2 cycles is acceptable.
> 

