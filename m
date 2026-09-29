Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AEF2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B996B00A1; Tue, 29 Sep 2026 04:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863EE6B00A2; Tue, 29 Sep 2026 04:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779FF6B00A4; Tue, 29 Sep 2026 04:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1216B00A1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:38:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE37E1C2A6B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:38:20 +0000 (UTC)
X-FDA: 85266147960.12.84F20B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44CF7120005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:38:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Et/NCyQT";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iz5ZvXuN69BjPyv2G6HIms6qrpA+v8co7aU/JAxPMNE=;
	b=i4WJKSLeuiGv978ZU5GC8as1BcXGAc83fkQ7qxq2JlSQMUnbrK0LX1MWg6WdMrwV7vShvU
	mzCplAiOwgx1h6gVb4Ssj1s9C7HaocUeUcu72P3FU+v2st1j69BNY2Zj0523WbSUkTUPl5
	VQuAN34cW+eu6n2XJxYu0mXy+UrKslg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Et/NCyQT";
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671099;
	b=nW3WM4Q8UWs/2+9h1lfYF2SP0xPHFeMO/VS/X+HNvlM9gbSOmEfjCxdEW2PLSYAch6SZgm
	Tnj1+1BQaPgMA6LxG4WiznyCC0m9pooiXmWxWOIWRiCCp333QEQE9dRmUqsFw3yTvZj7ir
	UKtn2aUoB1ZLygNhWj3i9pm5WjsxyBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDB2A60A66;
	Tue, 29 Sep 2026 08:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5181F00893;
	Tue, 29 Sep 2026 08:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671098;
	bh=iz5ZvXuN69BjPyv2G6HIms6qrpA+v8co7aU/JAxPMNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Et/NCyQT7O69s/oTI0wI7TsZqQZ4BKiyPwlsmyvZXaQwi6qYH4wC3HNeG35KmYtdH
	 16rbfDWcY6FBulk3pCXZCBheSHbR9CKUreOrvVx3NIhT7iCgFzBli+GdrMeL4jt0OV
	 YLI8pC3bxAe3iZ8dFIAfaafOfqEp0davudYDsxUtIuq0nLLrku3xYuaxY0tyqTuR2g
	 pj0kzTGZQIz3VPo51nFxAT7rSF1q7zfdCXsZOSWXu/5oc1hhLBrdPpY0IMfzngOaFp
	 Sy6yMxjf3TFy9xHuVCBlwfoO1EMkOp79jWNfE5AxYmtByip1HcmC65oDtgLLGlR2pv
	 YzDvp8g8KS7gg==
Date: Tue, 29 Sep 2026 09:38:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Park Tae-sun <ts930@dgu.ac.kr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <art47ZLD3Ioxw_1I@gremlin>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179066531783.50175.13377521828379196177@dgu.ac.kr>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44CF7120005
X-Rspam-User: 
X-Stat-Signature: ewr99xu6dx1pjaidjxgawd85jq9cqi6w
X-HE-Tag: 1790671099-360855
X-HE-Meta: U2FsdGVkX1+XAbtuIwoIECGA5PyAjf21TdxSjSHOyEdhADLu3P2shMN7LU3lmuO2n3mNTKaTrPiwXdJ5VuDn+VL4Gl5vlKfzCPibTnYkvfhxWAhQ9qORFohsV7vBv07cjmVCq/d81pmX3lXBAAtw1t26+ZI8aGTMXMNhQf2NySR2yqr32q1FALSK5GhE2rR8BInH9040g8zdEoRWEM54FwsKB57mI5XVj/O3U13At//G3EI2Rpzb6yvoutX1avwdSgTzodECR1xWMGrdCwr1ZTNYIUIpwrq5eUro8HoB9TW0ePJnS5D67GhmEwCiUTZ2HcFYFYsGIRATS/73dGlT6eZFsE75nZWLjgMxoyPDDgCu6kI+irF4esDOHv8iquQb05yX9ItQoPF8N7stY50KHO8BSCTy8fC+PPhJ71QCeLJEtM4uGuVVBJVMpwSC0Mo3ba/SYdNxIEhTSHgIXfCBzrfgDUHKjvK75qarrOb3f/FXPQwWbaPBk4j9iESCgvh7EE3ghXbw2cDZX8gIdoiyAGkBPKRY40VAlVp8mUjxfAihuh/+XMBK5leqMIeTcNGzxqtjtf7ZxXbqeWy159OFHtWjvOEudsrun+bd9b8KAeV/0enEgXfUEXpRNGBivEjBmcqwKNE0BxqdpKMjKbZGETYbAe73yq60K+h4o8raRec1Eco/wst5mUiCakUE0TY5hc9+cgf9CPfGx9WLUHpX7CYFfosJQJ3arvA2Ei+vgiwmr+hyzgzU5TTONUSEPp1hkaBb67vlkFAdI9i0Z7awUlefbZUxesk47Wp5FCjFlnJagEQmQxYq1Hk7OUsddKtLLQMT35PFUCo3HbyZFGHlSCQ4sM1/56DjmutIUvX1r1yT77wOfBwmGDJHAJo0VOLNpse9LvYBXHYYAb3Iy+JFoS1mrHLyAduJB+YKuEWguf7lY8aU2GFWolkC1x4C5sWp8NM9hKsKbi+mRVRDMQO
 rNj862hC
 VdNYH8fjWVy3egtZnlVxej3nFRL90TFeI0fZhWIdi/AUhV8ZWJQ0NGZzR1rSM2O59jW0lxtH0OedkimobMEazMjCncCPhUD1NEXjVk1s4fObhIdd3C1U1syqvBfJY0/rqokG+orOVpxeHuYJVEc5yXIPeUp58u0kV4sNfWpCltucmuNzGrfZQPW4NpHq25/6l6ddX/M/AerAsMFdddMm7r3rpFlN3B4iYWKwJ+aJwjsAprhwEFRL1NqWOV7xPX26qKMHgo2o7VZsENisrATAf7S1qdGZC7jQHyUojSsxC/0Ps6RYHvawTqg75bS60p1Ju0da0npixHEqVeQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

For one of several possible reasons this mail has triggered an AI
detector script.

Note that, while we are fine with AI assistance, it is kernel
policy that you must disclose this with an Assisted-by tag like:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

It is also kernel policy that you must fully understand and take
responsibility for every patch that you send.

See https://docs.kernel.org/process/generated-content.html most
notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

--
Cheers, Lorenzo

