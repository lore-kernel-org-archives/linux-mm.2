Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 995F7CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6168E000C; Thu,  6 Nov 2025 03:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18798E0002; Thu,  6 Nov 2025 03:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E7F8E000C; Thu,  6 Nov 2025 03:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B26ED8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:47:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 639EF13B5D5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:47:15 +0000 (UTC)
X-FDA: 84079552830.06.511B19B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2A36D140004
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:47:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D7Kmda0G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b346HRNJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D7Kmda0G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b346HRNJ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762418833; a=rsa-sha256;
	cv=none;
	b=vfKBMx+sYr530wlcHRV56dfPqffCW7SGTO4jx5HHjE4JyyqQkoDtFBHzbGHLFTAX5U8tE+
	mKoO2B0+KZZGEhT+XPRzPQPQVLxyi7Rmjy+0KLSeZPLXbk7HOE5mvb8OLB2Dh61KInlcTk
	gSdKni+fu4g4iodqeD0LV/GBHmOMZEE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D7Kmda0G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b346HRNJ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D7Kmda0G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=b346HRNJ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762418833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9JKRyZqRIzeeD2jmnhtIuap9opd/wOkmcUgyeZHF30=;
	b=ClkhQZfQrBhh2gMwlx5DyP86q8r4ESAOoxFD/PLjtoOYXOYeTu5gk1EAIK2PZVGs3TYiMn
	FYfhyq96T70BXeWAR/RCSiiDPZzay0S244WBfR1Z5LPTUMinluPWrvNWhu9W02xu5cpdg3
	NZeRViB+OmvoyP85QIEIRq6ZDovg8rU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5BF9A1F393;
	Thu,  6 Nov 2025 08:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762418831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9JKRyZqRIzeeD2jmnhtIuap9opd/wOkmcUgyeZHF30=;
	b=D7Kmda0G3Z7SHhwzQH+EkEv8Y5m4wFUgwE875yybFFsOfsYVRdQmq5OBQ5o2Cp8rY5Mp79
	Z9UitGp/NNfdd34g1YUBEpwWTqrmr0sd3qLmZOVETnUhjrL/JDdqCSL81iBTsG9bfCvTHo
	GcUvY85XYF0CaHqbpI0PoQ3jHRMS3mQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762418831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9JKRyZqRIzeeD2jmnhtIuap9opd/wOkmcUgyeZHF30=;
	b=b346HRNJPV99Cmed5Qf0YuTSpglLJxc2xoL9ehP+c8NyfPGle8Q+9zUKwtBZTnCyEneqY3
	87xWEOeKvxbSpRBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762418831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9JKRyZqRIzeeD2jmnhtIuap9opd/wOkmcUgyeZHF30=;
	b=D7Kmda0G3Z7SHhwzQH+EkEv8Y5m4wFUgwE875yybFFsOfsYVRdQmq5OBQ5o2Cp8rY5Mp79
	Z9UitGp/NNfdd34g1YUBEpwWTqrmr0sd3qLmZOVETnUhjrL/JDdqCSL81iBTsG9bfCvTHo
	GcUvY85XYF0CaHqbpI0PoQ3jHRMS3mQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762418831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g9JKRyZqRIzeeD2jmnhtIuap9opd/wOkmcUgyeZHF30=;
	b=b346HRNJPV99Cmed5Qf0YuTSpglLJxc2xoL9ehP+c8NyfPGle8Q+9zUKwtBZTnCyEneqY3
	87xWEOeKvxbSpRBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB97013A31;
	Thu,  6 Nov 2025 08:47:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uQquNY5gDGlLaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 06 Nov 2025 08:47:10 +0000
Date: Thu, 6 Nov 2025 08:47:09 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Robert Dinse <nanook@eskimo.com>
Cc: mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
Message-ID: <yd3kw6xvpq3vf6m5mjsnd76fy5fowgfytwdieohohq3wndgfia@b3in7oxevjhk>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
 <erytfim3m6fy7qy3tmfwwkr6ymvyfoevhwsac4xtadimei6ux5@um6ylfu5e4ci>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <erytfim3m6fy7qy3tmfwwkr6ymvyfoevhwsac4xtadimei6ux5@um6ylfu5e4ci>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2A36D140004
X-Stat-Signature: 9qgnog5qanrrscgq6bczbjs3w3ofkftb
X-HE-Tag: 1762418832-839753
X-HE-Meta: U2FsdGVkX19Cog2YMNyNFFI/+Cz3asrKFbxkBxP1/7DfrXrMOgwL8cWfYQBXJT8djuC/AnAtQCePz9T5S9muXyhLUABJybFXUGuXuv6kmZf6AE7/V751zEdukFFz9Gvigk1LsTXP/XP3DgNEiPAwZBxVPer2wqsRcKOMhpUZ+IWkQH+Sar5eN0PefjSSC4Qfwf/V2JaVtptZhPywdjHZlM7g8jQDJXKZT3J3P4ASiX5dij+EnCaCZKnNqOUVZOY3/YgQESRZMRxBoN2hLqYqQnUMwKFfHS9DEGCNWJg8XlWL/8ERJx5M3eOviW2BaBQ0+lvTP429dA+xQXd9VaV0qZebjlQBJYYbn69CTFL3UpSGky9GlmAik3xOGiXSXxfWKJDmwVlSufcyvKaZNY7K/hF1HJ1+A41rzj+JTxMRUcrM3kO+zydl2NTlKyTQD06FMzAYXVP8TsQ09GnBlwV3rf5/5A1ajw06RcL1vbffMcav4ynD3/qpcbSZ+0X3n38G/gFtQ7U5KxryJNS7djEPO4kFqifuJIEAyQ4z9wAmeFlgfBGkudQ2q0wlXz/gjo6pGJlyaohOGjUDnVlUxWYpQjrfBB1mVQBvWgQbgauZ5vOrthtTLe9Vm38kZSp9I16oKhnkmVqxf8tcEm8oIe9pAOLebTZrj0E3JrPt49QYbYT+sExGf+didPgcEnqCqKJbLVPXK0gwhIiX/I1d50ZUP8s4WNB/FJ1U84xHoSurW7AQw/5S9goiKjXUcX5Vkfdeo2hbYdDZX3zgy6FocQTowWukXpBLXNuJ/M9vY0i3Ye35JJjE2n2WyyPeF8zSerUP1+kShasm3pwbDOw7TuXwn/0Io77AHGo3+88WGiyVNb1DMki9VkZilLd6XVrq6V75qwB0E8hBPWvXo0ZWPFUb6x5drqdQm8a8MqwGNV5ZJlvpk8LcV17RyuGa15ZvbdllsoJSh31a1k8zX5w2qT9
 KFK0YbpQ
 tAwfCec38sk0o+fT41mTEzniXa67JY7EEntE0CHpoX1nJUdMUHec9dEsYMNs9ULhtXZNcSAwJ2RqvqU0pdNGvJ7u/QXTQXKjVHfRI9ZOsVIvfCkV1j7BRQTHdz/UDiY82r36dzM0ChFVt3QQOrZUmggjss6EjIkYGV8TWxJQWxaQDP2B08cJIczVQzwFUjt5YyN3P9C2MLw9wqiZI5HV3rxWZ2eK2tOMNS7GTe8XeZ/dPIQ9poroDXC6LwI0kS2E15RBeDt+OHDv8/TPB6oCGL1rRZeQwVNiUcUXST8TXbjYeCTrc1NoowXv7wDtrZWHiPey5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 08:43:25AM +0000, Pedro Falcato wrote:
> On Wed, Nov 05, 2025 at 07:19:17PM -0800, Robert Dinse wrote:
> >       Since 6.17.5 I have twice had one of my servers lock up in a state
> > where it still routed network traffic and responded to pings but no user
> > programs are running.
> > 
> >      These are proceeded by kernel splats:
> >
> 
> Are you sure it didn't ever repro on 6.17.5?

s/on/before/g, obviously.

-- 
Pedro

