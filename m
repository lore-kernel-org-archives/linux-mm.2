Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9172D606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=M8vMa1hA
Received: by kanga.kvack.org (Postfix)
	id B06B06B00EF; Fri, 30 Oct 2026 11:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE1A6B05B1; Fri, 30 Oct 2026 11:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4036B05B2; Fri, 30 Oct 2026 11:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72A2A6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:11:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E8E7C0791
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:11:22 +0000 (UTC)
X-FDA: 85379631204.26.C863880
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id 64355C0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 15:11:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=M8vMa1hA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793373080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
	b=juikeCh/aahWgG/AuoRDYbOyhSOYLEt+4CJFk61OeDbtI12rhnpmrkXfvFmtmXk92Oquz/
	y/phJuNWD6FQdL+uHSnDjmaJSr/mZNENIStjt8faz0L+L5tV5grrBL+FSZWslF0VUQfw8e
	hUFiwB/DYeo2EcrNt/rR6faX/at54yI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=M8vMa1hA;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.52 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793373080;
	b=DS8CNBM8dHLs+SqHuWAYtX2ASNEHEciZiFRiOSyyP8yFNpyND7AL7XGWAFSYdcesguVe06
	SUreZXMyl40yClwPw1Jeo8if3Kz5pDlcqRfn+qdFi5gTeAKKelsCuUx5vRScWduhGyv8A7
	CWj+T5P6rbjwULJ7oqcPFBANMTjTHgo=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c719669a8so8828166d6.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793373079; x=1793977879; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
        b=M8vMa1hA3rX/2LouGi9q3qdOv/F8he+8jwmR6iHlU4b6WBHG0PjW+LNKshdzrYPiS6
         oXEnUpXkkc8mwzXqJo0q2pR8582gdkiYfVB2/7ckEs2t5SZ6muw4KkGTxUi/3j3klBb9
         6WL3eJ7W6QQLsmYtZvSxjU4BC6qAQG3MXuBaWyKXgz6L28BQ7evZSRP4nKSuvT4pXIag
         21vgTPu9gyoFciq7bJ70h/Wqai3C/dd81jtr7kvWOzJB/FlhBGS2Re5Vz8g1r3KevPat
         MVWt234Ia/3uRyf+OtFCKmIDZQY4qHGWbfb+MKfOSa0WGhnnqGQFTMT7AnaMsBDisnOm
         h/Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793373079; x=1793977879;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SknYW3+pVsCwOENllYU3jowrrCPEotGjBjq9wVk1tW0=;
        b=2r0Qh2F3G4jzb7VDWtSofkRV5uZyunhNeQb9CwwpWpN4t3Jq0wyFXihuEMXE365HKe
         6ABqQ3bHRUPewh01ZqwUPsjVlxLOuyCOrnH4VtJKmFHSesZy0XkRAf4trYFp6sfU/JZy
         /+bI8oGkOhbQD4coT1CymyPVT/BndZbjW/f2iNSYUpQfGZghxK5ILz5LsuW+q4rT3mqh
         d/3XT1HbEZWobLV+4VVIbpaF5TVUAcqGpbmXRcMLnXazCreG4vzdJ3p72+/l8aHmRl/2
         AMDpScExf4L3Zg3HFfFxXKqtRmZDEmrRcV4KuNBuDozNnz3pelJYWaBE7qJxWv92Lm2c
         JB6Q==
X-Forwarded-Encrypted: i=1; AKwUvBz21HbqXKKfYH12iAwfGB/48Y6mYgFWHQ9PZ5IaDDqFukjBsQmA5ECwAotRWP8iathxmwH2XKu1/w==@kvack.org
X-Gm-Message-State: AFq9FYI9CuNY7+pLpEQUFP4ABdnsILkbBuUJWeUbkEJfRZS5XETTvsuG
	QY7zHZje8kII3mXnetm11aK+5J6xJBaHBPnbZY4TlnMNBl1svHcgqjXBJsy3T9m2o9E=
X-Gm-Gg: AYBFou3Y/Xtlnc2JfL7J39H9KG/5ueBDrvqiDXDVT5Zlaaw74smIZt4lRDp+iv8e+jB
	h2zBUnskEZNQq0bX7Yq+dKHc/4eaZzst60wPeZzHlE9Ut94aUkotoTpAI7aojjaXEHdbkH6OOtr
	0e7KxdxoI2MJUMqwcfhNz6/ykmeua+o9toswMewgm5tVtYtMRY5N4QDdKRK5U9EH4Vo8zRuXWOe
	KNsLZ3WbGaEt9mvjq1sZ4kEdJSiC491Yzx+oVXlqEseLNxthcOPzd++r2wkkfVlBcJm5tlLTAve
	3W+V8eRYDfCV+NBvlcoYeBx9ZnJ4VBKPdHxXoOWPD2pmGugP8OwpT+Ob6jX+zSVFTCVfk3ZTVJA
	E+boCZ9h3LllYleGJNI9pQhl2zsggsoOOqzBvn4xJK7dbPdalrallfAuSGI5fhNnYs6TfZrovMD
	jbdjCxeWpooMjxpROGw+3BauLwmGvwM7O6M/bR8seyCN3n+kTOzk/qcT0cFrpz8p077mOQouCcF
	fVjfRrTkUChfFJEwr2/wp5eWYYKUSkLaJCqKtD5CtAwewOJvYXN2CfZZYsjPJCZeA3GClTrwANW
	ehNn+MykU2apCIMq9uvACtSB59spafMqzqEr9egQ5Fji3/bKt7ADJO2HqF7l4zPkA29f6sBOKEg
	K0DkxOCdB0Cc=
X-Received: by 2002:a05:6214:29ec:b0:91c:5fc4:ec2f with SMTP id 6a1803df08f44-91ca4b0dc32mr40691666d6.26.1793373079235;
        Fri, 30 Oct 2026 08:11:19 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca807047bsm17117606d6.39.2026.10.30.08.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 08:11:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMoGB-00000000v1Y-0kVg;
	Fri, 30 Oct 2026 12:11:15 -0300
Date: Fri, 30 Oct 2026 12:11:15 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <20261030151115.GD3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Rspamd-Queue-Id: 64355C0005
X-Stat-Signature: q4rm8bpyrky6wwojwdhxns9mkxmf9qji
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793373080-671669
X-HE-Meta: U2FsdGVkX1+t4b6hqr8beAEjcWmUjXnMQZO1UGnEwwy7wHsnaDlZqYtfo+lv49fgmfnpDAO5Eqt0BYsArd31mwB21OFBnkbux7hEDWnYGfrvYzaPe5u2YIpKdKbNpTz5YOuury4fUejSFVcJ0PvZOelc+FkXLlaWmtZEqByUvFmtQo8tOgt/J8JQN1PRr95+WoN6VmzUPcK2bRm1vsqOqLdCY6W9ofeQLajN+CNWnwutBVR7zlaxJf4wFbb7FkBSjfkytzjqpxD0rSUsmcgUVOGxZE/+1Z1tUBGHQIZHhITHl53eOZaaVA90gHE4XFhVyb2w+3bujijFw5EhHlss6TgbTjZfG5kjczL8obe9bd1q0/XBb0JKvz1eHRfdi/uxqOe1wM5PtoEI86EcLNlt1ySfzwghWZn5ZpoqGhYYwP85fodTuL2Hc0aXDJ9E9EajE7j8QfLVfOmuzKiBJkqRNHM4EK1kta6s6eXNVJZ4bnLHRmMTuNvwA8cJDupIXwGoJ/zjA2HWXuwi6tnUnvYcjjpNvqpxTCyocAwMSk3JXykLPv3aJjNFm3rKaa7k4ffb64f68ZPb6Lfz/dm3LSYgD59dtXr1PLoEvbAkpavCdugTXtb5EEgpS7M0nlOhQRGSrIL/aqCFv9IkuFmsJAeQ5IeyUK84t2S1l6JQFBzGiQd6JJKHfO30p4906ns9B0NcOiMmkZCqq14nHwFpK/Thl/YkNU/AKvi2KCO0WbRpo2xQEkwz13QI8LgiLhF/QKp0wpMauCQg/3eeIavKSONx+dUbprGXORpwgqmnAN9PfM2/mpr1WsgvNWZOtLzKc5520emL0MGhkGUF8K9JISJawOtKcc1P/zvnpmHRQZbjXduxnYZY3BqPqbUFkPuX9671wfRp2ZZ8kXdkSG/HxEOzwH6ILaT37smhjgJ3rD+bDgk3y/LxIlDjazbK17nlSzPEOHfozlhdu8XXcXiX4pR
 TwlyrhqP
 2fWa7ZiVawTeGUqqYQoYA22eQyCXkbrcBO0agOVh8Cpe1CxVIkeGmClrzuxlBUSVKCxKxYAAb4ZuCPqmOFAV6gg9+OwJZIVPpbFePyFQZy02ND2LGbzT7uHcwMUyDNpjXsda8QNHGiAJIDXDFGZQraPz0VVAmzZmfoah7SAdapx+aN0v5WooU6/qiZAUJSCRd8UwjbHshH4m7NdCFjEDrFF+Nf6hnFAAwYNWtuKtlRsH8of6PylqaDGIZCklOKotBr1FMbeU2AvJpr8wWPjGTr8RWTH2uaYwmP71RL7Ii40GN7LblmCDNN3ea9rA+Gbr5BtIZj4dF5GsIuDzGWG4u/Oaoj/ehTebEHiUs6at04a+zlUCW3Yw4mgNhgWKz9RpL4pycDsPlawZnAldMLBzbjPn3gGNxmJOlkkdL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:

> >> I don't see a reason to make userspace (that should not shoot itself into the
> >> foot) a kernel feature it must activate itself to not shoot itself into the foot.
> > 
> > The issue is live update doesn't preserve those background punched
> > folios and now we have created an UAF attack on the kernel across
> > kexec if you don't do something about it.
> > 
> > There was some notion here that with the right sealing flags we could
> > tell if everything was 'live update compatible' and then know that
> > these attacks are impossible.
> Just remember that there was any hole punch and refuse to live update this instance.
> 
> We could likely implement "we saw hole punch on a pinned folio" as well, but I
> don't think that's required initially.
> 
> No need for more shaky seals.

Ah, yeah that might work out. It has to be checked really late though,
after userspace cannot change the memfd any further.

Jason

