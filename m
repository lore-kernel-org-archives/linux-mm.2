Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88904CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D2F9001AE; Thu, 14 Aug 2025 13:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174E8900172; Thu, 14 Aug 2025 13:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2129001AE; Thu, 14 Aug 2025 13:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F00DA900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:10:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97C62C0741
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:10:50 +0000 (UTC)
X-FDA: 83776002660.30.6A6AA85
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9ADF340013
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:10:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cXsWYLOX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755191449; a=rsa-sha256;
	cv=none;
	b=4LE4IAYhArfB51H6krVJrU7dLZgS21afcPbPjEV0tAnxwh66xYXvmEAkjWpozzhLMdwT70
	xr2rycWgB5aD8caYeT+Y4d3N4xfHbcoxORKD8sLYym/KnT9iYV9qDatS/creFzSQ/UmBUB
	7GM+ocUXAvFayMF58iPwELaFIBPMULg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cXsWYLOX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755191449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b72U+nUww1KIINPCaJtfTVRc5RFVRFTZ9UiCYeqDFTM=;
	b=GvQFLKJp1Ip2t6qDIPz6Um/dKF/3xcMMlYDloCKXOYJEqSrBiTM9xJR15258CvsLOAWbRp
	3070ike9f/HetySkxJCt+qkh0eVKiwDAYGNx88IgM6RLbBPKHUKQyxo8YrAl+bdFgXkfvk
	5WBsjnDXxqJhiwaHxPZ4CIsoprZV8aU=
Date: Thu, 14 Aug 2025 10:10:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755191446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b72U+nUww1KIINPCaJtfTVRc5RFVRFTZ9UiCYeqDFTM=;
	b=cXsWYLOXEk20ToAZj4NZeb4vbiW+anqqntunu2SZjI0Z27Wukw1bISf3JD/U8jT2xAaxyO
	fq5tGOPqHQ3QaByLt6HkqisNdCpm/3pEzcd6n1ya0V6+EN69wKb3UM4Hcki9s7sc+h3xpo
	6iYHyz9wzFN3ymO2uVI8Jg8VLgSnfbk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
Message-ID: <23roz4za55rarfkzcz2ej6m5mqwouzjcpvnfvn37mo7jeqk2t2@somfzyl5kf5b>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
 <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
 <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
 <oafk5om7v5vtxjmo5rtwy6ullprfaf6mk2lh4km7alj3dtainn@jql2rih5es4n>
 <e6c8fa06-c76c-49e7-a027-0a7b610f1e9c@linux.dev>
 <CAAVpQUD6hCY2FDWKVnoiQ59RmovLizTPCC+ZNqB=oyP5B4-2Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUD6hCY2FDWKVnoiQ59RmovLizTPCC+ZNqB=oyP5B4-2Aw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ADF340013
X-Stat-Signature: smn31h1yjuk4xbiogwpm5aascdsno4bc
X-HE-Tag: 1755191448-75167
X-HE-Meta: U2FsdGVkX19Hhd5uBTZJyoNzaZCSZaDJoYp4bRq8ZBYWWs1+mIpwemw1abxs18FnKYB2CRGhw/K3O50wEfrQOyGgrNUs8ggz2FDXfX6hqOkcAX461jn2JnjJeSw90Bhrz54pVoPA/mfHE7cfSdmngVMkxdz97OunU/t7k7w9D7D1W+huuIKrVFI6+R6XspjUJ+aU/FtppGt/N7EbFRZ+WZ3sJUUa2qkSr3Mi65GWE1c41oHEGmfeIlItd/m8qBLATOJQt436Kg9Lbkb5kwhTpFicLZoaFn8mHtyYh1PuqaZXHMzmqnXcGFlZ5VNUP23cQCY+moRxpLzAm3OotMFP3cIa6Yp+A4s5mR/jSpLJ3MUvI/S2H8VZUVKJoHDaNVleemlfUE1N1rH69rqklj9OJgmK/7wGtZmCPS3wdGXuIYMyKlnzQpmN7miuV11l7WggyyfSm4vV5j3XKB0wZIrvGwJYTrAF2brUdmf2B136f/hGdDMDswDUS2Sx+IXJJ4YDiY0irgzlQ4DHsDLySWYHAN6MoJAQCvrLaPVx0xATAZSxYNL5b4qZ2TxCDLwTIJahJvvGWgwi9BwBOtNIw7V5LOkOfLc3gzv9pY05E7QGdKazED5pXcOKSFs+vGup+dzxRwdJrJn3yrtUBeXUOe2M12WiCWwjUHh1mv4YhbAu/Z5XlHlWTYuIICugLW+K6OxO2rUjRd10+gWyTfgwCphr7zdnvDklPwvAWfI0aPm2Nubv5VuR1gBN0rwewUhmvrflTUKSms+nCvIjAx8m4aXce26AVCSmWUn98XWadHUwHAfctoH+LbvGfA59CwStFPtG3v2rA1AyM1U49Pgw8bz5JIQaluMmmAyrmM9jyLzMqyEDOHTNq9McEU0sFAt4EAgLbFHJSRws9DHy1EIaYIPXD+lpdSWzcn1kpizcD2fxwRnfbKohGfD7sb+kDUgBODjqi29GiqCebV587WSyMF/
 rZw9SxQ1
 u3hjDpqul3ThocQroNXkcUohegV85WXOMGkiaQ+Pec6cBsAjxjxYOP088TTM7wjrNtywo1LLkrASl3s+/Iu7LsV/hj8RaLd8mCGhnZxlc1BMmpDbwKl4GhBx80OqshNrDYoR5CdkZvDKo6maMuYRs0Qg9n2NUAKxvSTyPXH8N58SsBWZ0RKPsxBdC6BaaOaGpHGjN7wDGKVqWviI656L+eX17DLEHYb0+LrYq2Ilp5saX3dI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 09:34:01PM -0700, Kuniyuki Iwashima wrote:
> On Wed, Aug 13, 2025 at 5:55 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >
> > On 8/13/25 1:53 PM, Shakeel Butt wrote:
> > > What I think is the right approach is to have BPF struct ops based
> > > approach with possible callback 'is this socket under pressure' or maybe
> > > 'is this socket isolated' and then you can do whatever you want in those
> > > callbacks. In this way your can follow the same approach of caching the
> > > result in kernel (lower bits of sk->sk_memcg).
> > >
> > > I am CCing bpf list to get some suggestions or concerns on this
> > > approach.
> >
> > I have quickly looked at the set. In patch 11, it sets a bit in sk->sk_memcg.
> >
> > On the bpf side, there are already cgroup bpf progs that can do bpf_setsockopt
> > on a sk, so the same can be done here. The bpf_setsockopt does not have to set
> > option/knob that is only available in the uapi in case we don't want to expose
> > this to the user space.
> >
> > The cgroup bpf prog (BPF_CGROUP_INET_SOCK_CREATE) can already be run when a
> > "inet" sock is created. This hook (i.e. attach_type) does not have access to
> > bpf_setsockopt but should be easy to add.
> 
> Okay, I will try the bpf_setsockopt() approach.
> Should I post patch 1-10 to net-next separately ?
> They are pure net material to gather memcg code under CONFIG_MEMCG.

Yes please.

