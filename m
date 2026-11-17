Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C25F0606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 18:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dghtSMLa
Received: by kanga.kvack.org (Postfix)
	id DB91F6B00EF; Tue, 17 Nov 2026 13:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68F86B05B0; Tue, 17 Nov 2026 13:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30706B05B1; Tue, 17 Nov 2026 13:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3C3F6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:49:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 31A4D140512
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:49:02 +0000 (UTC)
X-FDA: 85445498124.23.CCC3EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D4C040007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:49:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dghtSMLa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794941340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBH8GWBE2ux0ZLech9LQWrX9OAnUt3MRaq8g2z5zn/A=;
	b=sqqwDHK7ZUBXQb625DxOvxSZqLrjU2nnx/w6LE0V/6XvvLOWAmAb3GEWLWFmVCOs/qGHIa
	yBRlL4i8ArBgo98E5QIMAQWXF1YN4mDcFOUilejQOaoD1ulsR8H3YLylPMiiDJfs6pDluK
	Gk883oSpcrrmOxoU5A1dL0fAQqfkWgk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dghtSMLa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794941340;
	b=ZdFtuyYq1wCyN1Fcu+2y8BXWwtYcqQqNURdfrDZbXenH7eJjtAPYt4BGMkAKAJ52pKS4XF
	Y4scIatqYSL9SXTUIv7d8vgO/6wgLBOGU4wz63z3Q85j6G80utHQ6jOiiYkGTiax8AG4Pe
	BInOr1BcM+0SFxli4sbdZo+oGIJshm4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id D8CC76025F;
	Tue, 17 Nov 2026 18:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D41EE1F000C7;
	Tue, 17 Nov 2026 18:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794941339;
	bh=EBH8GWBE2ux0ZLech9LQWrX9OAnUt3MRaq8g2z5zn/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dghtSMLaGGyJ5qkER8V/xPxhL/adkndfHqymiKb5Hw/7dfqZg1jL4wCIfsST0G+AU
	 g2psE4L2ZUXtFK0gJsGF2+u6HoRvlBYppN4yxXuNW9ix+Nm22CsC/UE7R9qFo6tcGj
	 GOSvVgfmVGOSjQDxEn+C88zqKeko75i0Gmiq1YLpH8gqCyef3aYoX5AQseW+QVIO5d
	 zr4VOhkcIGVe7KSEDGMkaFPUY1+7+1DSIkC4aZgAtQI9WW7bG9NGMxtc62tAF83oH3
	 JRcpQjqRrP581VoOpArh/92vWjCZq6isBbEnAYFFb9AGjBZlduwtgfhNIUQrTVF6MI
	 yevfi9pzlIaHg==
Date: Tue, 17 Nov 2026 20:48:55 +0200
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
Message-ID: <avyhl79pygUmV3hr@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
 <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUBUnJVhiMkft6hTZZMe8nTpMBRTGY2v=9x5ETBSvmPZQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8D4C040007
X-Stat-Signature: zrhqki6gcdpohmjtkwmcmd4h49oqhkxf
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794941340-503434
X-HE-Meta: U2FsdGVkX1+AdUmV3rnVp0MNF6480Z9KSvxFgH52C0DLfhkt8DgfCBnkUEj0exwjBoMVGZPDUkslMDHtej/FEUwti2Lk8tGV7P8ocesicFrG/HaGAjWcQkn4A491jloLKRd28FRUGyzkTIoxjI6ERV3iIyI7nVX3t9jFiFN+3t92lDmbCASL9vB0kWubF5mBRti2ogYq/FxeIdmVEctThlxWVjrSOiPWwoedu7Mvo7bqgZpHsc+AQnoqwjIq0rsiBusql+ZblJpGNR0IXU+c9FB7SKmEPo0YS9jMko6IM2roX8BXypccMD3zTc786XtlFq9DaIElY9CdhhyavnEb8TQWZIc701uTNqISnsVXIOJPwMndd4DkQK02qn39GpBcfeRHpuQ2+Lx0GchyKzOHpaMEMSm4R4GNt/WYKyq9qmoGB1kXRBcrdiVx+AEQ1fS4xhqxsK2TldDbWNsv+PB6SDGgJhYHRXLMcqJhfBjnTzP6Tczfzdxmyb/WAA342Y9MlCWa3AZFB3IoRSxKf8vqThLYuA/XMuL7hIhAQO0WTnko4fDi10QlHEdKZWdOrd1dADkGcJjEYOUur1/fc/T/FavYtVrr2e34PUZHPjXpN/oVNbvLjVnNEd/GAX7neWcTV83Y/n2O+2rb+u6U7nOxULzU5NvypZl2dsn1EME5MzPPjyup9oeo1HBdJcBd8M0uPS5J4szilLOUmvs8pUIGgAENhyt80nxbHhgi41zc4iuAqdYs96FWUWE7WfE4pGnPsDaVSw9qeYvhWdRE4Mmtu2yleXB7Xci4sLAheaOwcm/XzBPukZvR8az1LSvzcg4od4aLEionFfYq3Zql+mECuZljBstFOd7slCg1Ibwl9BWsiedeW37S0pBXszgbXr4nADPu2biGzLnx3DsBad3nWSH/8HQJp3JCHzR4AvT+bXXPFpyeeUqtYZ69ZA4Hc1YHim1Jyigpbz5sBTfIBhR
 AEwj6ZKl
 57HNCsruGsluYsdUny0wxVgzHgJeIrTCbc+2CK9czCXuDQ6AH8KkZfUGIlOtIQYQhie+vn+uY/oIQkOCwMWziMDqGjKBOKlxL+X3VQxG7EgxWdLje812JrCOrG2mEsaOV+Zc/D04fAxr1rhq14XEDyFJ4tSWA3fYOOHTVMfj82iFeiNYE58Yq8XIbDK0DUs267nGqL97f4r1jBYX1JMJdA2cN0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 09:44:43AM -0800, Andy Lutomirski wrote:
> Can you clarify what this new API actually does?  I've read this three
> times, and the best understanding I've come up with is that you've
> designed a way to create a group of namespaces identified by an fd and
> you're adding an API to configure and enter them cleanly.  Which
> sounds very sensible.  But I'm completely confused as to why a
> namespace needs to be owned by a "rootns" or why that ownership
> affects even newly created sub-namespaces.

I think this would postulate the patch set:

1. A subset of detached namespaces.
2. A dedicated PID namespace for spawning into, signaling members, and
   polling/waiting on init exit.
3. Initially an empty mount mount namespace that must be populated
   before going live.

I had to do some head scratching for the second question as I've worked
seriously on this already some time ago but I think it was as follows.

If recall it correctly, rootns ownership tracking was meant to stop
processes inside a rootns from calling setns() into host or other
namespaces of the other containers.

However, user_namespace already enforces namespace ownership for
setns(), and adding a separate rootns check prevents legitimately
entering a shared external namespace (such as a pre-created netns).

I will drop the rootns ownership tracking.

> 
> --Andy
> -- 
> Andy Lutomirski
> AMA Capital Management, LLC

Br, Jarkko

