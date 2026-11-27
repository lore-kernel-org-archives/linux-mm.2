Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DA39606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W5ddae1+
Received: by kanga.kvack.org (Postfix)
	id 4D2946B05BF; Fri, 27 Nov 2026 17:43:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAC96B05C0; Fri, 27 Nov 2026 17:43:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7AE6B05C1; Fri, 27 Nov 2026 17:43:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16C166B05BF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:43:15 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 791ABA80B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:43:14 +0000 (UTC)
X-FDA: 85482376308.26.3329355
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C8A00A000F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:43:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W5ddae1+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795819392;
	b=esFr7ZLGO4A/oz1FwvF355NQeLMU8vidHiu8mwV37sOOzyylHptvfKlLBfsPlzzb7GmSgs
	B0aDRgywbMFCOH80PAFIpdqmVt+2/rhqt8iGqJWxsbM8h1MJAVoKCsj3BYPUNjOSmJU/mB
	cd23GT9JLLYl7IAMeD0KvC5VSg1+LzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vr8Cyu6OnN1kywiPQZaviQUiC/sNy6ZdV1ZpB2i7LQ8=;
	b=IPFQglyAHSevpjWvIKowQxjJwODwsFY9g2+gnKraclSm3n8HxWg72tSWmlliqociJlUiuW
	FX3VNIXlmfpnchj28aOwanXN8/THO9KVHEToSa3kj0SQMudq8hy5t4d//ipHIRLKCa1ttD
	Tg3ZPlZvR0LrWFAbMIht7Kjwky4jR7I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W5ddae1+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 4803760CFB;
	Fri, 27 Nov 2026 22:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4CE231F00893;
	Fri, 27 Nov 2026 22:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795819392;
	bh=vr8Cyu6OnN1kywiPQZaviQUiC/sNy6ZdV1ZpB2i7LQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W5ddae1+sL0M2BwMEOdWKEDvyU78Ny8CC5zKR352ZLpxUqa01Td+Izg20p0wQGrbH
	 kYcjC0YhQscAjvW+ApK3sdygTP8a7FLherXbJr0a4aU6HQkiL0/0KzbR2XYHXgrO9L
	 zTbNPmRsA/nZx161YRb4X85NouktelTHL8XkEOUlt8557iQkYLcCgtTCteVfbqrKNq
	 jAoUGNa7psyvgxoLT67SvgzE9A6+tIXgw4+05s+YjDB6qyZ1n06lLnwNr2H8/9mLyy
	 wPzuWkybJdpCQ1XDao0m0W2VH045/GO1mbqtmySdCWfE/02b7oG5tNg/QYvZ2McDsv
	 Ae5amWfVTo5dw==
Date: Sat, 28 Nov 2026 00:43:07 +0200
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
Message-ID: <awoHex4LVst2JwkO@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
 <awn_Y7oI4ckfsjSv@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awn_Y7oI4ckfsjSv@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8A00A000F
X-Stat-Signature: 39zuu1p3a3c65g7smru9eq9cwmtb7qms
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795819392-853288
X-HE-Meta: U2FsdGVkX1/ZtUb/FG3dPykqnismmkgt7szyXbIOeTCvsnJDtRvYXGpUdHjvBX4+4dR9VEghVk3tAOHVEHe6tm9GYHHeUUuvwPU5Zu+71DGgcykZJ3ysdsxF+QvucdV+RTzfjARAi9wf+wo7iulGzU7xR1RSubztuOtm8T/mHZ9WKGi0xaX5onh1zR6SbliQNFTPfLWb9rCifObn9YqzKbYt72frzsX4I3GCVbmVs1kljuZJg7VnhAgUEXbS9IKfDRnEuieklywVk3IFZJipELYMpQiosxiiWk5YQQL/85Qj3rKs1jzsa+8wLnUDABwdHwFQqmjNgbIalhEdEQJJ3qH0ZM8Y4b45oHNLgccBHpuN35THgdbBnyeZuTYbo8d8dF8GOu0uMtrFE4Rq3LlGfEv9UswfKmPSZIPxuQC7X8yfaUcONkK+zc2l9EeTsYu+ISB6t6/EoSshLnZ/OXKcyMGP6QJfwUrfMAIaItJlLdy7P940cZU3GZizIVHAboAw8VB/OzwEJGn0GmtDyp/002/3c9ATTGs8h8qy/qMFmAcrRkoYc+OVHM5PbSdGRpq0SNDSoQfWFdVgBTc2wNokJkPp4H8x9kX/q93TSLBYcwVoxpGRacHMEZvl/oWruFlGcPWYoboUoZyTAEVKvIrlATM8tCnp/3GeKxXFJkOJSHvXjdANVnJbcE6lLGPA88llf9YT2aGuFeMyGZu9AH9h/RWhyZ01waUPs3PFCrL6zENoPAuLZ7c64+JWYBbVEc02fZXe1dPyzXH2oc0WZ/jFCc9Z9omIN30M707Wxu2skIS9Szvc7o2VC0cTGRcEDXuXnTlyrg2HP8xaPEyz9ZpQ48+7dQuqCxu6lxu/+/zcnYGY7J5GhvCTdyXnML9u+WvHQlmerpzbGOHGhlKhlT5dk54JGnYEp+LXdPfHJ1FNJxeBH0uLwtRBJr57YYiDeTLmZSzxwIlXK4VRuIkaymI
 f2ucSTcV
 IFWfi+yvxR+C10nSHwr5697w/Red0PlQX8jEQsHfpiX/kNjispR39vxkWg/87e507r4wNnQ8QkVoyqp4KZ5iA7ohTQt0j/tbXSQ/j6RK5Qr3NxQ55MtOaPdG2JUTgNVMCaLcXfUXakbdMjKVZhNbJe77g/ZjFplWi1rjN7wPEMoQRyYUlsewkqO8pIyzq/o7y5jKVZmzhMy6sbTJmWhYJkIR+acIVBoGNqeZoCQuRC5q5FkFAFg+72IgdK5lGbSirLByekO5kBPQH+uIwUwyOrOlcEWwsZPXHskNAXIzQOlNpyFQFvDc+JnXPbZI4M3Fni56i0MgP8DTgbRLTOpzjgXQqEvIWuLt7Qyl7EvwQUfyB7+SvVeq56y59WfySuum8UikX3ORFoXNfRpXTxutJSUgp8phEFb3dA9BOvQRBrsSX6S3lv1uyJcjf/6wHTHVC1lW+eLMpnkurG9r6gs4eZQ6bpEeA90s7LNdDi3FxMhaFVPNod+KUS1CTSaKIKrunFiNIEQh27ZoMMdauLKumwKY9RCstgylHejau
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 12:08:38AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > > Jarkko Sakkinen <jarkko@kernel.org>:
> > > > I personally think that "getting in" should not be a goal in the first
> > > > place. I care more about that whaever gets in has a high bar of
> > > > quality enough. It can be something different than this but
> > > > when I read the LWN article about Cells I was alarmed enough
> > > > so that I had to do this and prove my point.
> > > 
> > > I think that Bacik's patchset has better chances than yours.
> > > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > > because Brauner reacted positively:
> > > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > > 
> > > So I suggest reading Bacik's patchset and say what you don't like about it.
> > > You will have chance to influence Bacik's proposal before it will be merged.
> > 
> > I've read it through and the way I'm seeing it is that it is overdoing,
> > and has somewhat complicated life-cycle model tbh. I don't like it.
> > 
> > This could be of course wrong way to see things and I did this just
> > to demonstrate that similar goals can be achieved with a relatively
> > lightweight core. And this is also demonstrated with a Python daemon
> > emulating Cells style containers (and alos relatively trivial SystemD
> > wiring).
> > 
> > There's no reason to continue this for the time being as it
> > demonstrates already how I see the world i.e., "I showed the
> > code". It's up to whoever decides these what they do.
> 
> And even if Cells is the ultimate solution since I had thought about the
> whole problem 1.5 years (mainly for my own entertainment but still) this
> was the best way to unpurge all of that. Regardless, world became a
> better place... New information arrived.

When it comes to containers and namespaces I even don't want to have
any opinions tbh, because it is so opionated area to begin with. Thus,
I pushed back sending anything using this approach for a year.

Despite the patch set tsunami (sorry about that, shit started to 
unpurge as I went on), I was not too hesitate to send this in the
first place, or have no motivation to compete with any solution.

I did all this really for the sake of rightful concerns about the
complexity of the mainstream approach; and in that sense I'm happy about
myself.

Br, Jarkko

