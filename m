Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 246BF606A333
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TMG9hdFI
Received: by kanga.kvack.org (Postfix)
	id E2D996B00EF; Tue, 17 Nov 2026 14:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8006B05B0; Tue, 17 Nov 2026 14:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C813E6B05B1; Tue, 17 Nov 2026 14:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF606B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:10:58 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33ADD16056A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:10:58 +0000 (UTC)
X-FDA: 85445553396.30.C8FEFFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 936D24000F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:10:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMG9hdFI;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794942656;
	b=dmZH6heMBuvgG3HFv8mDkFEhtmM4F5iHit76mHYdn+mX7180tdB4tVMeMYNIe/n65ohjUG
	o7z4JS7VCnSL3WO/B/gVCT71CKyh9xhjjxA5PfSwBugKSx8qB3RdFN/G6/24WKIVvu03rA
	Pns43FkkmjZ8x8ljLK+iPxv3haH8cQE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMG9hdFI;
	spf=pass (imf07.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794942656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNfr1N4SlD4nY5lF2k9NOu1qbIPKIuO18d/t7UojEjc=;
	b=pazpv4TffPtiryehxCO1dM12yRobS7lrQGLdbMS5TA/lRq9d/0tmMCbAx1jatHk89HJ85I
	tD3HbkmqB+gAwVX1aGXTqVaieFq0bsVf65oPJ/X/SR1cub1ym4g6aLeMcqMo+c1YMU2Xhp
	cea67u3CwHH8xZZfjqze/xr/wB6WwwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 16EB3611C6;
	Tue, 17 Nov 2026 19:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F13BF1F000C5;
	Tue, 17 Nov 2026 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794942655;
	bh=QNfr1N4SlD4nY5lF2k9NOu1qbIPKIuO18d/t7UojEjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TMG9hdFI1EiKm12mX2UfRyknIADhNhlisQjyVgB+nCZZIPENEdznv9MneSRYCr7Jv
	 HMIiYw0QYp+qamQPfqOrdhty/ANjv5b9t7CPGrzmhSWmN0XeNjxDExZisM1vNvkZvB
	 UpFB4zHnjkbCr/HfYSCFcCYHjOMWmCUI8BqO2hltxJwBEOdKZRFeWWXCvOnxV672ni
	 hHG6+lRX18Q4qayZUEfaQ5BY2rNuiw3UDZQHStPfEkyhjUU3Pa3cZ+aY5TyWhz3hm2
	 x85mHaTn5JdLS3Brs0i5acaJvE7jsp6MiQ19Qk5biIFf1aBXXwe2VxmXxpdXZJxtFy
	 ROeBDjhz/LeQw==
Date: Tue, 17 Nov 2026 21:10:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
Message-ID: <avymvCZGVcEp8mHu@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
 <avyhl79pygUmV3hr@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avyhl79pygUmV3hr@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 936D24000F
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: j4ssbimoiq1adzig7id91aa4tig8c7tp
X-Rspam-User: 
X-HE-Tag: 1794942656-600220
X-HE-Meta: U2FsdGVkX18sSZODMzIWhPCArzX7v9aFFTqyuRep1wvNA7u7RMr3Uv7Y/taNsEB/C0wHJpKJk8JMecmHlExenJZRIyRr7XoSMjGtnHeqcdo7a1RX8Wx2eInBA2h6681GK2uiPOGTUt2n9zCX4lTrfksC/qxnzXIRVW51JIops5biR33Fk8OuVQlPhNBqiIoNkIv9jcwLceyEv/h5kPejTxK6c4MkXZQRY1uHEXb4VAsaUso0mujXi1LKAgM+BDFhODCtTdxHhNfgWYQRbKUobXDctC2EQSHHWIzy0oOolRvSRTWxakA5tR6WUvX/s1SGKTF/RYf1elYdOws3eC5rG0xSqZVgLJsqo+rB7SMAQgMiCxnF8rHZf7w6MC4ShRTwAs5x9tBlilj9fv7gQSU67t3N96OjlavJJhcR4M85jQ5VXkV0TqtqReI+U3SPp59A1y04XwsY6H/HCldQwBooFpZQCo+jvM2H+1irA+pNSdWAUQYlavS9X/kzpuYsnVq7w7Yta8pW0VEElhuvYE9XnRCnPPK4iuKkZSmpgqg4LWr/pM/ZfmaqLCEB1lmpVSUGIGmcsPLE9otl2nHomheAZtwTSiBLLvpHUPTISGIdUzvewe4pUxdr+zgFzsdsZiEjVVs2mj8LaMscTbmlD6yVsOA13vDN5fsuxnthju/0h9CxwAJX2rtlBmUB52/5a00UFXxN5fQQQfOslNemavNVn2qr9KdklT6/xCUFxcAIH0tR8FbecbYgwIcXuY6GDtGhyrmHhjNtecPmMZOzKsolRBnTq2reGGem9kFoE+K+TEF4m8/kE3UShbpuBMs3c+yflvAMbX10pK6oodC9Yu+BH7ZbxW9/MrTgO9Ymz39tGric1a1wfIR0UD+We4GgH33C0JXI3mC4jmSLHQHK5wPIeDEwJT6nPdydNY8SIdwrCOV36zHvXYK1hHe6zx/pcIeTzxZ86bCgCVQWT3yp26p
 yHSnRjXM
 NtJN+EHJwiYKFI72BPCYAvJ8/aJ6JmEAjzkrQBBTtEnW8StZOgbhgxzEJriUahMWSTFwuY6XEHLgyv3icsv6ViIaWwyQBNaneY9x8oE3HgAlm0iCu7xiW0Odp9MoB4KKJp2mppJ6RLGUox8Wvid00fOjA6pPLdMu2C4xH1ynWOFn9osm0jjexf1TMrsbSlO549ODnCvKSZWR4IgyQtg4jZ9vnfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 08:48:59PM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 17, 2026 at 09:44:43AM -0800, Andy Lutomirski wrote:
> > Can you clarify what this new API actually does?  I've read this three
> > times, and the best understanding I've come up with is that you've
> > designed a way to create a group of namespaces identified by an fd and
> > you're adding an API to configure and enter them cleanly.  Which
> > sounds very sensible.  But I'm completely confused as to why a
> > namespace needs to be owned by a "rootns" or why that ownership
> > affects even newly created sub-namespaces.
> 
> I think this would postulate the patch set:
> 
> 1. A subset of detached namespaces.
> 2. A dedicated PID namespace for spawning into, signaling members, and
>    polling/waiting on init exit.
> 3. Initially an empty mount mount namespace that must be populated
>    before going live.
> 
> I had to do some head scratching for the second question as I've worked
> seriously on this already some time ago but I think it was as follows.
> 
> If recall it correctly, rootns ownership tracking was meant to stop
> processes inside a rootns from calling setns() into host or other
> namespaces of the other containers.
> 
> However, user_namespace already enforces namespace ownership for
> setns(), and adding a separate rootns check prevents legitimately
> entering a shared external namespace (such as a pre-created netns).
> 
> I will drop the rootns ownership tracking.

While the patch set itself is manually coded, I got inspired by LLM
agents back then. It was quite clear that in the near future OCI
runtimes should try to minimize the live configuration surface.

Another force was that whatever the solution ever can be it should be
made migration friendly for OCI runtimes. This led to the conclusion
that we need yet another namespace instead of a fully parallel
framework.

Br, Jarkko

