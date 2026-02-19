Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A0EEE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0186B0088; Thu, 19 Feb 2026 04:54:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97DE86B0089; Thu, 19 Feb 2026 04:54:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3B86B008A; Thu, 19 Feb 2026 04:54:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 73E336B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:54:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24A8A1603F2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:54:53 +0000 (UTC)
X-FDA: 84460747266.12.A72AEE7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id D7BA040011
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:54:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BNoOW7Ta;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rGfDI4Sz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BNoOW7Ta;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rGfDI4Sz;
	spf=pass (imf07.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771494891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3e7k0CMgUbTj2xC5pAxQgef7+E5hHmV9itvXo3DbZGE=;
	b=sKHPJIp9kTbKq7z5cSLCMGoDiR/wwQjRlEVzzlUKtG1evnn7nWakF0KLvsXpm2xVCYvM6Y
	TkeQXJUEGgEhdxOtVPAhqZmoLCokTGFuMEhvOnAzk0WkKL0xkQjvzE++oRixdM7BCJQBZO
	4/xtQktl9Qlg8Sjbla53uKU+m9Rqy1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771494891; a=rsa-sha256;
	cv=none;
	b=xjrczfZvqDfQsbJXjneUwog/AG8awMcRZAotL4XqDhfG7qKy1ZrLyCnklncqczuG5X9IWE
	BzVzCe2Rlf7tugtZ2LqMYlUO6vLrKp3ef1uIX2/TqK1BcMq198OPkyJNPpVkbcUI6oA0Zu
	GEGR0rtacJoKBbPvZ8p4pZngdChfNUA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BNoOW7Ta;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rGfDI4Sz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BNoOW7Ta;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rGfDI4Sz;
	spf=pass (imf07.hostedemail.com: domain of hare@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 313055BCC7;
	Thu, 19 Feb 2026 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771494889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3e7k0CMgUbTj2xC5pAxQgef7+E5hHmV9itvXo3DbZGE=;
	b=BNoOW7Ta9bzhOeu6BmeXIU3CukJpHmWhf3JW9U55bYDe1aXhPML9SZx/SzLQpHYLhXmhJ4
	XeVGHpBZQJ5QgPfCDgDwY8fSwMdoEGtFGUPljC2m7xODa/LGoDYo8q+ddBM8B+1FuVelER
	/Ms74PK1QoBqlMqzd9RmTdfnKCvairE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771494889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3e7k0CMgUbTj2xC5pAxQgef7+E5hHmV9itvXo3DbZGE=;
	b=rGfDI4SzjwY8KzuPdzLugT9WuovU6r0d+qVBpZP4QOsfeUm8yoYUXuMpMaf13jorWQpw7T
	DKkwtNsJvzv8ZWDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771494889; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3e7k0CMgUbTj2xC5pAxQgef7+E5hHmV9itvXo3DbZGE=;
	b=BNoOW7Ta9bzhOeu6BmeXIU3CukJpHmWhf3JW9U55bYDe1aXhPML9SZx/SzLQpHYLhXmhJ4
	XeVGHpBZQJ5QgPfCDgDwY8fSwMdoEGtFGUPljC2m7xODa/LGoDYo8q+ddBM8B+1FuVelER
	/Ms74PK1QoBqlMqzd9RmTdfnKCvairE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771494889;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3e7k0CMgUbTj2xC5pAxQgef7+E5hHmV9itvXo3DbZGE=;
	b=rGfDI4SzjwY8KzuPdzLugT9WuovU6r0d+qVBpZP4QOsfeUm8yoYUXuMpMaf13jorWQpw7T
	DKkwtNsJvzv8ZWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7D9B3EA68;
	Thu, 19 Feb 2026 09:54:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c/GwNujdlmkBSgAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 19 Feb 2026 09:54:48 +0000
Message-ID: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
Date: Thu, 19 Feb 2026 10:54:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: lsf-pc <lsf-pc@lists.linux-foundation.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 linux-mm@kvack.org
From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam09
X-Stat-Signature: oh81rero4bum1tyd8yot1o8yycfg1cyw
X-Rspamd-Queue-Id: D7BA040011
X-Rspam-User: 
X-HE-Tag: 1771494890-46077
X-HE-Meta: U2FsdGVkX19RAn9hVTbR2FKGAnf+AvLUzgGlpNMPLIOXPe2wUFkvYpbsxJe6yEpnXPg5l5MJtLyAIrL1k5nqqRhnKAJ862yV/BNIz++MaJ1y91nx9W+gWhGXF5yEnlUtzx7GRXirvoI+M5lJc1zW5h3g/It76kIwlzhueWcLPKjpXtdmUnyi5cU98Gz3pBHr88bORn6Ntvye1IKmauhxvnTq2jO9LOPJYgnseEBre2JJBP1yQEoy6EU7JJDBEphkglw95Yz+7epuLfkK2idmtBRBR2HHGKtZB0o3WsySELDvy7orvgyQrAVZOxFVpFp0LQ6ezM+1IhZshPiOmvqMCNbz9z7HwDNd0O5Mhre+6XvhmwLMxS8G9K8D+/vYBOvFy305u6mW8t4ixic4vJM26eRr7BZtZcecINcrvHO1MWUKpwixNtWP7F4yOD3z3lMoAxV8oMt/bT9i5N+NTMzWrYFIud0cDp3Yw3s2HIqNygnGz55AZjLqG8craCczYQjN/KdBm2GYwdFhYt5oQ5/BBOMxIOYj6lChqwSJmiektxld23rWJxejaz7u8iCbEs+wdBVCgAiUa4lo45e82zzh2VDzpLNmb1Uzz6OZwKlo5+eLK+fH/8ygatAICXnfaR/Tqd2210BiQPZ1o9UVu43AXfZabu6698Q5btSANKoew9T8B/0bNTJ121sd4zaV54r6ru8RBRRwTjp+fjEQIvpUuZ6sgmpMZucn4ZmX/uX9D9ep9t0PtX+l3D4wYW+2Ri+xyBj/RckIZN9wvjjQfgeDh0ta1W2KQ/IwNOfKTW9DCFvalI5hoJwJqdeWJV5NgKMHUw9k39LBU7PrTWkLTVGHIy1nfMdHkerI1Z+41dsdDDGGTSUUX3e4aaXnPZi0lEBGOEz7XRlfuK/tj2MyaBH2X/+u+NsfJXBcmhW08+6XlGHJiS6uTKBVzO1tc8qMrBVhP8jzzEptk51IVuhLNOL
 TpYFY5AC
 ELe/AaPHjJStdFVVd4GoU9g+bKcq1jfrY5V1/mA7+GOM8my6gAOlb212g2La13XVIXdYXE4S3qkSuB7PcBxPTe6RtX6OdU/lum5HZ2FPmIzjAFFO3rQVwXGeXHYgC0Z7IvzTvfCjPEGkCkX4poNROksZwl78y1eAPvMf2eZ4o1h0+J6zNE8dmxfZ6GeZp8H62MrE+1S7+NHRNzUtqt7jVV41Jta6cEVUCUsMwJ4dO1W6Hu02Tfvyr9puk4oGNIyE6kkiR8+q9JyP5wXfDjfYee+iVKCm3HJKu6MtgLXZKIugpoCwKH1zJAsoWmeWd0px82RccI4dRKZ6nXaJa0vr48Xq7xSSJixEqr6gr1PlEYtC8Ho1cUGHI1JEEWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I (together with the Czech Technical University) did some experiments 
trying to measure memory fragmentation with large block sizes.
Testbed used was an nvme setup talking to a nvmet storage over
the network.

Doing so raised some challenges:

- How do you _generate_ memory fragmentation? The MM subsystem is
   precisely geared up to avoid it, so you would need to come up
   with some idea how to defeat it. With the help from Willy I managed
   to come up with something, but I really would like to discuss
   what would be the best option here.
- What is acceptable memory fragmentation? Are we good enough if the
   measured fragmentation does not grow during the test runs?
- Do we have better visibility into memory fragmentation other than
   just reading /proc/buddyinfo?

And, of course, I would like to present (and discuss) the results
of the testruns done on 4k, 8k, and 16k blocksizes.

Not sure if this should be a storage or MM topic; I'll let the
lsf-pc decide.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich


