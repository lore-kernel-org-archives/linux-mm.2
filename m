Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F30C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 21:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D266B0095; Sat, 22 Aug 2026 17:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D116B00A0; Sat, 22 Aug 2026 17:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663DF6B00A1; Sat, 22 Aug 2026 17:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43D486B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 17:52:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C98341601EE
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:52:40 +0000 (UTC)
X-FDA: 85130255280.12.1CD1C2A
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf01.hostedemail.com (Postfix) with ESMTP id F36E140006
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 21:52:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787435559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEt8O7LRcCyZgmO9qoneCT5b17y2bffjN5bHSaZ1+eQ=;
	b=M15L/zYkBJ8f3NSnC7Ajcz9tq1Vvu+kLfnK5CXl0QVeQD8VO/sk6eOBUwmkGJjPlK2lm5M
	kDBpkXDa+dRkYOWH9zcdralUMzBtw8aK9z1pzaO/V7tEXU4+LjNcyHO4iI8wwwWd8jOEmE
	bwN7L2DfAVK70tM23V9uUhTBZ6toAN4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787435559;
	b=ulKF/xxNbk6YtcMbXU8nJmswSi1tmvbXjqhOB5Q08W5ikHQNI4yW4ZXh1gSTdhhhpvKDMg
	gUjKx+fEBMjdVudcV2Bmam8dY5bjwUe5Tr0QQXhHEdDz1/1+voVLUCbcs5bRyMvHIMjNbY
	2RoMvqAAw1+yCkIYNolsOJS9eG/MZ+k=
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6DDC34020C;
	Sat, 22 Aug 2026 21:52:37 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 14AC830;
	Sat, 22 Aug 2026 21:52:21 +0000 (UTC)
Date: Sat, 22 Aug 2026 17:52:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bradley Morgan <include@grrlz.net>
Cc: =?UTF-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, bsegall@google.com,
 dietmar.eggemann@arm.com, kees@kernel.org, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
Message-ID: <20260822175209.3bc255d3@fedora>
In-Reply-To: <20260822170928.1acba2cc@fedora>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
	<20260822170928.1acba2cc@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18o9nZPijjm5fLztvCCYL2gxznxJRGXRfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=pEt8O7LRcCyZgmO9qoneCT5b17y2bffjN5bHSaZ1+eQ=; b=PThRT9JFyMELxlt4cDT4fWfwjdtR7AgQl9vRmrqmB1Y0I9sKW+S0KsrzrOsJpcrldSRFc2iN71iMuTJNFm7Zo4egyYwX1MYPOUn97SpBbCbjB2v2chfOJVv1vUuWDAJeWWohshECSRwo+pGqlFBK/zkBiqxLAEMZYms9D1JJgJw=
X-HE-Meta: U2FsdGVkX19UINL0mmjW3hpFQxrhf/7zY2aOpgFoZTxOywy6YXM+r6/gNO/T+lLGHzD/Xbox/2BzdIxNf+HbCZpVOcRoj2LT68FMo14DGhu7Tdv9WRXcWJ0rMyDnf/sijEig2VhxgnptJgcRLP5jgEfg0Vc+yakLccQB4HsruOWMZ0mbLZG9E6XrT9jEvnWGj6bcD8tJzEOQmkw6eX+jm92d7nDJ2pC3SJXPVB0y8dSpifkSsEZQWD48mbAeOGY+Rn/LePQn4/38xbCd7mEytgfAN6MCZxEtUXHGBt72PB+pKvAzil/f0b7HqvNOvxT8hgS3tnHptvs3c9UAz0aSZc24pDAY1YFAVWzI7x8AjXcIl5ubOzp+P1MIwMVpIO96
X-Rspamd-Queue-Id: F36E140006
X-Stat-Signature: oecqcq3jg44x6sad1zai3jhigekgdk18
X-HE-Tag-Orig: 1787435541-503601
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787435558-121777
X-HE-Meta: U2FsdGVkX1+hlD7GA0tIzURae+taHkXd+EiA5S7ytZKRUsqi3/oFjx4hXoM7FwFjFY5MZlagVdt7j55Expvc4CpcpgB3bxsqEgUTsyXXAJC+hpPhI/NjIY68uFNbSsfKp2NzA+1H+8NoRq+0AtQBXfQ90dCpeevb8K8QQSQHnYScLwhWZOEr+M9GtwnZP3phlUGOoDKOM43q+vvtcfMVe5aIqNdviLtJqPsMa5ENK+v5+bnQsMJqHChws2tnJ2ut9su4rpDjVq2oHK8cUZv4ek15oXEHMBzN8Jw9Mlgm22bmYDdiy/B9JjSxQugjmc9Tt7mSGk0pRne2VLwrX+Bks81Czs0VOBm/DQyBB1uiK/gIeArrTlsdL42BB/gVWUItAD1yCtqCqg8FtdzL7xcsjMJeRgBpZpAGRxyVk3sq4P65EKeAS3gvRvAVU8EG2ien0h4XF7at8VccyGcevy3PfuroQ+uaPvabRiClszaBIQ582nFbOQuGHR+vOKyzqrn/NOLKBW19cK1IYdDF13b+Y/7R1hYGvZH49B0umRG/THJSZUS2OCRNdm2adCc0xClj9uDJ7bpspeMz5niBKQJ1XSJF7qCUHA7TO/aKKmowYNFgf7AGMPFsSZPlBgNOMimqoyERApQoOQhPgVL5B5eTEw3QmUscvpClaNPll6Ao8KHTUeaQEY/AY8crIsSL2DMFAczohLdJzIKXwvUwi6BrsrW8cWwqbKZsLRU4KqHIlU9f1kEug+GAeMwajjMYfIi4p6hhbTm8s7q0DfbDUlaK0ePAWHKlDQCJk7c01bmMSr2xWh3WKoeRqn34K4w+0DbzD2UWdUdZxi72o5L0VOpfgp9C3fHTtjTWy/9hI6FYwRaD8dNa4mzQi3I288Q/7Xw4XaVvEuyC+82bkdPx5U8XJQU2ei2z+G2cLhLiaBOUFL8i5tnFrp7v88NS2FIdIv+jkXsFQsx8JuZCTOHZGNT
 jlKb3ko3
 7FhdeDcKdZfRxtWUa4JkQh7eaWYGA2bLktfRlJLLHbg7sLfAuJJmVv+/aEI09BnhUnSMdC00dEoNyPvcfhEYfYKnS0an3U1HRCFCnblTBLIUH8CWqYrNHu+DKg2DyDAFADQRi3PoY6JFiph72uS3YiyWwv3PL66urJS9ELHS230NJoCdZN7zGypZ4PXepk3VBPB+8pwySXyzycc7OMccmDJ3RSt18iywKoAwIyL7MYj0eq1QinYrXlzOxkSNioNtqyYlDO60MmcLsVTHpJjBJl+PGlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Aug 2026 17:09:28 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > >Resending v2     
> > 
> > (no! V3!!)   
> 
> Right, when resending, it is best to add "[RESEND]" to the subject:

I shouldn't have said "right" because it wasn't. You add "RESEND" not
v3. You should not up the version if the patch has not changed and you
are only resending to update the Cc. I do that all the time.

-- Steve

> 
>    [RESEND][PATCH v2] fork: initialize function graph state before copy_exec_state()

