Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D14FAC9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEEB6B0088; Mon, 28 Sep 2026 04:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9FDA6B0096; Mon, 28 Sep 2026 04:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5706B0098; Mon, 28 Sep 2026 04:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADD216B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:47:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BED4C012E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:47:21 +0000 (UTC)
X-FDA: 85262541882.09.06651F5
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DE9A40009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:47:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=ggvWiPUR;
	spf=pass (imf17.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAouS6oU/GYqcmOPYHVkjxJ+emJPBFeGrdGUEqPX6cQ=;
	b=ZnHWTo+3BLDiUbhx2p2c42XDN4A6I0kcHTxC96rWwtE/s63OhrUq2aMbSRFbDuI+w5oXkW
	760XK/R9qDoMk989RYl2arAxzldFo5FVqUDj7H47GT01GevioX16ozQ/ncuaaUxK0yLwlc
	Ue+a8pf5IClUuY4byDOGpCWpz8ZqsNw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=ggvWiPUR;
	spf=pass (imf17.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585239;
	b=W3Z9VsWJ8FGisoH+ciUPpUTK6rxgHzqXHOcTF0TpBElXuV9yguOrQYxyMvLcsKeti23C76
	jQmsLAAXH2wWZpYVCqFnS3H3+FfRldRaEjZ55dzBzWcSnBwYWbvaweeLIa9rRuLCcoh5Uk
	T0aGF7Brfq//XQOqgSHjuk8tES+Zv4I=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 68S8l50M3267087
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 28 Sep 2026 10:47:05 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 68S8l50M3267087
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1790585226;
	bh=kAouS6oU/GYqcmOPYHVkjxJ+emJPBFeGrdGUEqPX6cQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ggvWiPURJ7O+r8S09SE/ntfPRiCWeiwdW4yOMLeHvMxXPH0Uj2iqca6oY3jAPfWEp
	 Na8QBasFHPGThNxNZFkyrHmYj3bTvJ3An1FNNYNvPaWjSz7KQFaowktfrFJqCbNaLi
	 /+z5RV8a2Bzjf8XNKX7SPOP16BqVK8h/v/47KiNw=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 68S8l4UW029489
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 28 Sep 2026 10:47:04 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 68S8l2Qo1976702
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 10:47:04 +0200
Date: Mon, 28 Sep 2026 10:47:02 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <arophkRJLItrzg/W@pcnci.linuxbox.cz>
References: <arY1Wq6R9OY20ans@pcnci.linuxbox.cz>
 <1a511636-7a55-4c98-a0b3-1ea0c301d749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a511636-7a55-4c98-a0b3-1ea0c301d749@redhat.com>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DE9A40009
X-Stat-Signature: 4egufd8i318jtnxnnek9h3wmuxeo5fr6
X-Rspam-User: 
X-HE-Tag: 1790585238-253117
X-HE-Meta: U2FsdGVkX1+C6YzNntg3z08rI63wHzne3uiPEhPNNS/nCcvF1gXLkMaVQjtU9RhzAqPKgzJZclEz4j35Z29rrO0jWIXb31Eh/GOrioTAvQHnvKyWW07s+TwcgCFCJXkLUlJPCvA4QfQqN7sj1SUAmqMzKTwFISwjJssVAD3GjWx53ofuw2EEnJ71SGSXFwfbsqz3vJBh76s9uLmNCMpm9HXlaN37oep0GUuSJF9xGvSRTys/edlDi8inp28HB/dFKsWijQuudGNxbFgyuTN5x394bDa4zY8b7l7L1S97OVcdmHhnd+C5Nt+8+DLMv1hYdq5sIVi8eB98SyTreGsU4ZlMOxeJZysn0Gm3LfItong/Y7kEzqbOBoTjhzVpXdCX3bd1pwLjKByF4Z0OMFixV5xSxPp28Jlzw7xt5OyNVguXrKTdG0XxQMrRXWI31aT6YcVqYUORqzc/pUhciWPhIX8KWV8ZmBQLTOtewk3dBMfN29LSDnikWKIzZRmIIKjknXf/adwe7YF0iLXtt4DeWXqi7S/zuHJqp33RzqIa/bkadYGrFtjC9OqIIZAJAtQDi25l+M0LXUgKDixB4YibAi3utZnl3NjusGR5JsoRGSswQB40dTAxtiJob5g5hLVu788Qsr83u+1ny7zY6ZAbq8VP41KVlzoksR3e0wSGXrmTevxskufxF4MBbW3EKlTh87kbQyDlH1SnCKtNMAZ/n4K5I9megq3pPkg8FQoqrADv7DTypQkEOW52VinUF0vX9RF/5gvuTSb6R3JlgcQb4uPMm1LKyNJmZRSTibJi86Pk1tT6V3/bHoQ50S3jxgKX/1Eaa1c/5gkzNjBGWiKQrHSisA5WO0imixN42IKCA/K2ze3uSzUb3hsSmTtiYVBULLJCJskRTAKGdq/nWH7/s9XeGpf42OlPNk1yd+fn9TiywBcQOfGzg7/YnJpo1iYko4bWKv6yjRNqLj5s2ja
 dSh045yK
 SJiV1x1eL2p8KKzUhg5y3diPTczR/sKjSDfeK8t8dpmnB8Ed2P+RSPvkzQ/peSTnZZP40ZGDSGVj9sdpfCLpfFcjT7oQ1J5GjaIHbqaexBvUM77TYSxHEtfqmPiiXQPOJtunBYq3L0rrk0P2GeoMhiPzsPu9wdbcvUsY6TPcMLTU9mRAZu0vL83/yUxn5qOS3y+vTEF8m5+AyG0eE3+PnpC+fDmH59e43t65oprrJDKJWcKInwdqwZlJxZjvfpwtGlrpQqAPfM8XSl8uhiCObhJZ4JzZKV6MB78FyS9BmUlaswVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz,

> > The problems started after we moved from 5.15.x to 6.18.x kernels.
> 
> How long does it take to reproduce? Can you reliably distinguish good
> from bad?

Unfortunately it is painfully hard to reproduce and thus almost impossible
to bisect. A few times, after more than a week of successful tests, I
deployed a "fixed" kernel to production... and got another crash after
three weeks :(

If I were able to reproduce it more easily, bisecting would probably be
the first thing I'd try, but I still haven't found an easy way to trigger
it.

I tried heavily loaded guests running MSSQL being hammered by HammerDB
(one of the affected customers runs lots of Windows guests with MSSQL),
and others running kernel builds in a loop on top of a tmpfs ramdisk,
all of them being migrated back and forth.


> 
> I know that Lorenzo jumped in and gave some good suggestions already,
> but in case you still find yourself without any further options you
> could consider if bisection is feasible: start with manual bisection
> to identify the first bad kernel between v5.15 and v6.18 and then the
> first bad -rc. You could go to git bisect from here, but it may take
> several weeks depending on how long it takes to reproduce.
> 
> Another option is to try latest Linus tree to see if the issue is there.
> If it's not there then it might have been fixed, in this case you could
> bisect for the fix (if feasible, of course).
> 

Yes, both approaches would be feasible if I were able to reproduce it
more easily :(

So for now I'm running another round of tests on 6.18.54, and I guess
I'll deploy it to the affected production clusters. That's still better
than waiting for a crash on the older release.

I'll report back once I have something new (from the lab or production).

cheers

nik



-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

