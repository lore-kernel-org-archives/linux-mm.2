Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF361C47BEA
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D976B008A; Tue,  6 Jan 2026 06:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A766B0093; Tue,  6 Jan 2026 06:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049826B0095; Tue,  6 Jan 2026 06:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E03E96B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:36:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42FE2C1F82
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:36:32 +0000 (UTC)
X-FDA: 84301336224.21.5520C06
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf05.hostedemail.com (Postfix) with ESMTP id E52B8100003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:36:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=ah+mVaBs;
	spf=pass (imf05.hostedemail.com: domain of michel.daenzer@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=michel.daenzer@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767699390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAmqeFdlWOAGRIi5evINvMoi90p8G0L9s9GZUo+ZNnU=;
	b=Dt08mSGEaF65h3IBVqh7wiKWb1QnrdC6ruJoBSD1Iccwqy/+qr0bJ9vi0uin/BSSlSUJrT
	iP4dB9JeUD18AEyap3eWf1munhWk9/MHTaE0p8kWzo8dPXvXPxgoPkiXWE0Lk+lHiH+UUl
	hZEjfod2i+IBtcqx8p2nYtwUk+g00hc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=ah+mVaBs;
	spf=pass (imf05.hostedemail.com: domain of michel.daenzer@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=michel.daenzer@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767699390; a=rsa-sha256;
	cv=none;
	b=yLmbhLdR8Bzab3Idje2kCcue0I0GWAbpOXaAawQcH1qTO58s7IQUbck6pzsa0k7R+HDMAl
	vYlvJJcKJ0nqfXQonxEd1aNTUQ71e4vYvW3pBssHhWXZ/ilmA2FEkrGLqCQSfUP9BHwBN3
	MZbf9rbMjs0jYqJ2W5yNX3wB0fJttdc=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4dlpyx1tPSz9srM;
	Tue,  6 Jan 2026 12:36:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1767699385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bAmqeFdlWOAGRIi5evINvMoi90p8G0L9s9GZUo+ZNnU=;
	b=ah+mVaBsxyCrWuJq0ICyA0wUs6qdvWHHEffzIOxZzoDfHemd/91ncSYxpx97QhP/x6Xx7t
	WMJqVFYqXZBfIPrnxbihfpX3TaTuxc0EEFysJs+MjETToA4+wVQb/Zr2TOMF1vmUUyWpLZ
	I1WI8Q3w6S0Tu0uVAchQ3NwLFLEzTf134oeD3UHiVTC5btx5iJ0HUCgeYiXMmbIhrZN6Dd
	n9dQku6N1qBOUGqE2lbkFMx28w3gQi21avSl9JKCYlzXPNeHn/3dEUvqtt3iRaZ8aweASZ
	2ROzNFrr8yjvwftDD9bz+7ZuG7IZ820R5HqH0NqsLfFxdn1DLAZuEpe86DgcHA==
Message-ID: <e597171a-cc64-4811-a043-db2e539aaf94@mailbox.org>
Date: Tue, 6 Jan 2026 12:36:20 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/3] mm: only interrupt taking all mm locks on fatal
 signal
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
References: <b672e17b-461d-16ae-e7d3-45d3c1aab142@redhat.com>
 <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
From: =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel.daenzer@mailbox.org>
Content-Language: en-CA
In-Reply-To: <7whbqlfrwjr4z2d4bpny3rjyl5tetdyx7ccf52uvby7hgywoym@6l6m2xcytez7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 7ceeee7f4f9448e5d4c
X-MBO-RS-META: tgxmey483p8e7gbw9y4cgr43xd49dy1g
X-Rspamd-Server: rspam02
X-Stat-Signature: 7en7pue84itjgsjqrmrf6puk7e5c31z4
X-Rspam-User: 
X-Rspamd-Queue-Id: E52B8100003
X-HE-Tag: 1767699389-535493
X-HE-Meta: U2FsdGVkX18BPqZ8ec9uZHaBmlLLCPZMF2THJsl8KUB5HAdiD50iHbH9TPABwZJSuOUM03jhUdIRhXL+Oc+SodYtAEA3YMnEHn//UmkKRHFBDvDj9CJGNHtsRHl5k1FkOnYXGuTV0MbZGTH+wXI9owEPOK7dGuzrqxU3FtIf3w/DSoXVI8fMIz5I+iIaxpYPuoX82F+oSouihrDjCpxrB7tmktv4wW1P0+U/9O/gNxz/tSZd4hJH63uoxf0EJzgoyBkP1vZJxwIzM//ABYAuoJN0TqkTbbfjxQJj7/H51ac1Yg6TMr9NsOsF1Pb8U90XcUybKeaNMDJ1saHdgZRQJ23qf4S3JS1aPN4fTjxO5Qd9RCFx4wsYkN0sH5RKO2Q8i7F8qduW02/gJbaOZKk1uZ4YRLM0363CMdboBzloR+MMTIeUZ/jkdw65nct/k6CO3olNPYLaqQyOydOd7Hvoet8BlxaAz1ceSJyWbShwHcVzPOdRa4hdSt6AxLg9a7la5yHKYCCywMsX4XoQS5VETimcy/xCQ4yawnPIg9WgmAAINLue6iMpnMR9rq1XKjZP1iFHv3U7MeNJFvB8OdgJYp3QA/cEamsdOI1TYQkXA1d26zY4bmYAofowhB2biJi0Ud9uQ8kFMnHUOJrFiXo7XMTK9BC8aWhLzicQYIWa/uhFvzAeL9inHd4LID5CIZWDhiuUdtDUREqu7FGV3C6AnN8/aywfQlSqZrMb7AL48fEIOi7iyrEwhJHGPnjZk1dYp7Q9z1M2WgZgMNmf05q+IY7ZMEPIdRB3VRs1Mx1G+LWHv8KlQk4fZr3YoqzRfNObYTaKnoKWbJl8UJeNsJ3tyGSrVc2pYDapc0zAxQ6i9BpawcOtsMmEKZ9qSZI2x0nZAnHe7yHU1t6S89WfHMYs/TrauyptVWENgy1A9FXvWIeE+8FCpAkeBHwWLWnrbUOhrMow2muJxP/VdQRNtst
 ljLrk4YP
 0LSQ5RBInZTvSLcyZ5uZubHxwKN8f+gR4IlYlS6Mt7kZ9d8e4JYxqu+586yiBmA+W2mdGFZCUiXBHuHt5PVbR/ZPtRDp3+Rzp3LfPkdsGyG15FCxw2qvsG256RJO0KXzD74wcGdewwzSPWJ0xy/MqLeeXPElRjb2C9c4b3rYUlOowp7a5MTcFSgu86tQZIhMmqrreE26hrbYE0wvsQfY/3gXJmwcQI5heluRWiSzh3UQjpTslUqq7fEIW93WULh23WbVYrjB008WiWOOQqxTDq8OH9YRo9gZL9M45o+ct77bIu2rM6IzsO8MWM04fVu20BCHWQIEvugOJi+gVYV8dHl5XErGNFnFioHUM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/5/26 19:15, Liam R. Howlett wrote:
> * Mikulas Patocka <mpatocka@redhat.com> [260104 16:17]:
>
> I'm not saying it's wrong to change the signal handling, but this is
> very much working around a bug in userspace constantly hammering a task
> with signals and then is surprised there is a response that the kernel
> was interrupted.

I'd go further than that. If user space fails to retry the system call in response to -EINTR, that's a user-space bug, period. It can happen anytime for any number of other reasons. (That most system calls happen to get away without it most of the time doesn't make it not a bug)

(This is assuming the system call can be safely retried, otherwise returning -EINTR to user space for non-fatal signals would be a kernel bug)


>> I'm submitting this patch for the stable kernels, because this bug may
>> cause random failures in any code that calls mm_take_all_locks.
> 
> They aren't random failures, they are a response to a signal sent to the
> process that may be taking a very long time to do something.
> 
> I really don't see how continuously sending signals at a short interval
> interrupting system calls can be considered random failures, especially
> when the return is -EINTR which literally means "Interrupted system
> call".  How else would you interrupt a system call, if not a signal?
> 
> I feel like we are making the code less versatile to work around the
> fact that userspace didn't realise that system calls could be
> interrupted without a fatal signal.
> 
> And from that view, I consider this a functional change and not a bug
> fix.

I agree.


-- 
Earthling Michel Dänzer       \        GNOME / Xwayland / Mesa developer
https://redhat.com             \               Libre software enthusiast

